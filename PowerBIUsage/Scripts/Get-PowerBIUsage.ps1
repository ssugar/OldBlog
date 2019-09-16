param(
    [switch]$startSubscription,
    [switch]$stopSubscription,
    [switch]$listSubscriptions,
    [switch]$passThru
)

#Azure AD Application Details
$appId = 'Application (client) ID gathered in Azure AD Application Step 5'
$tenantId = 'Directory (tenant) ID gathered in Azure AD Application Step 5'
$domain = 'primary domain used with this tenant - contoso.org'
$clientSecret = "Client secret gathered in Azure AD Application Step 7"
#Power BI Streaming Dataset Details
$powerBiEndpoint = "Endpoint URL gathered in Power BI Streaming Dataset Step 5"

function Get-MgmtAccessToken($appId, $domain, $clientSecret) {
    $resource = 'https://manage.office.com' 
    $clientSecret = [uri]::EscapeDataString($clientSecret)
    $uri = "https://login.windows.net/{0}/oauth2/token" -f $domain
    $body = "grant_type=client_Credentials&resource=$resource&client_id=$appId&client_secret=$clientSecret"
    $response = Invoke-RestMethod -Uri $uri -ContentType "application/x-www-form-urlencoded" -Body $body -Method "POST"
    $AccessToken = $response.access_token
    return $AccessToken
}
function New-AuditLogSubscription( $tenantId, $AccessToken) {
    $uri = "https://manage.office.com/api/1.0/$($tenantId)/activity/feed/subscriptions/start?contentType=Audit.General&PublisherIdentifier=$($tenantId)"
    $response = Invoke-RestMethod -Uri $uri -ContentType "application/x-www-form-urlencoded" -Headers @{'authorization'="Bearer $($AccessToken)"} -Method "POST"
    return $response
}
function Stop-AuditLogSubscription( $tenantId, $AccessToken) {
    $uri = "https://manage.office.com/api/1.0/$($tenantId)/activity/feed/subscriptions/stop?contentType=Audit.General&PublisherIdentifier=$($tenantId)"
    $response = Invoke-RestMethod -Uri $uri -ContentType "application/x-www-form-urlencoded" -Headers @{'authorization'="Bearer $($AccessToken)"} -Method "POST"
    return $response
}
function Get-AuditLogSubscriptions( $tenantId, $AccessToken) {
    $uri = "https://manage.office.com/api/1.0/$($tenantId)/activity/feed/subscriptions/list?PublisherIdentifier=$($tenantId)"
    $response = Invoke-RestMethod -Uri $uri -ContentType "application/x-www-form-urlencoded" -Headers @{'authorization'="Bearer $($AccessToken)"} -Method "GET"
    return $response
}
function Get-AuditLogSubscriptionContent( $tenantId, $AccessToken, $startTime, $endTime ) {
    $uri = "https://manage.office.com/api/1.0/$($tenantId)/activity/feed/subscriptions/content?contentType=Audit.General&startTime=$($startTime)&endTime=$($endTime)"
    $response = Invoke-RestMethod -Uri $uri -ContentType "application/x-www-form-urlencoded" -Headers @{'authorization'="Bearer $($AccessToken)"} -Method "GET"
    return $response
}
function Get-AuditLogSubscriptionContentBlob( $tenantId, $contentUri, $AccessToken ) {
    $uri = $contentUri
    $response = Invoke-RestMethod -Uri $uri -ContentType "application/x-www-form-urlencoded" -Headers @{'authorization'="Bearer $($AccessToken)"} -Method "GET"
    return $response
}
function Get-AuditLogEntries( $tenantId, $AccessToken, $startTime, $endTime) {
    $Content = Get-AuditLogSubscriptionContent -tenantId $tenantId -AccessToken $AccessToken -startTime $startTime -endTime $endTime
    $allBlobContent = @()
    foreach($item in $Content){
        $blobContent = Get-AuditLogSubscriptionContentBlob -tenantId $tenantId -AccessToken $AccessToken -contentUri $($item.contentUri)
        $allBlobContent += $blobContent
    }
    return $allBlobContent
}
function Push-ResultsToPowerBI( $powerBiEndpoint, $PowerBIEntries) {
    write-host "Loading latest results into BI Streaming dataset"
    foreach($entry in $PowerBIEntries){
        $payload = @{
        "CreationTime" = $entry.CreationTime
        "UserId" = $entry.UserId
        "Operation" = $entry.Operation
        "Workload" = $entry.Workload
        "Activity" = $entry.Activity
        "ReportName" = $entry.ReportName
        "WorkgroupName" = $entry.WorkgroupName
        "DatasetName" = $entry.DatasetName
        "DashboardName" = $entry.DashboardName
        }
        write-host "$($entry.CreationTime), $($entry.UserId), $($entry.Operation), $($entry.Workload), $($entry.Activity), $($entry.ReportName), $($entry.WorkgroupName), $($entry.DatasetName), $($entry.DashboardName)"
        $response = Invoke-RestMethod -Method Post -Uri "$powerBiEndpoint" -Body (ConvertTo-Json @($payload))
    }
}

#### Main Code Begins Here ####

$AccessToken = Get-MgmtAccessToken -appId $appId -domain $domain -clientSecret $clientSecret

if($startSubscription){ New-AuditLogSubscription -tenantId $tenantId -AccessToken $AccessToken }
if($stopSubscription){ Stop-AuditLogSubscription -tenantId $tenantId -AccessToken $AccessToken }
if($listSubscriptions){ Get-AuditLogSubscriptions -tenantId $tenantId -AccessToken $AccessToken }

#Get Start Date and End Date for Content Retrieval.  Default StartTime is 1 day ago.  Default EndTime is now.  Retain latest EndTime in a local file.
$lastendTimePath = ".\lastEndTime.txt"
$endTime = Get-Date
$endTimeString = Get-Date $endTime.ToUniversalTime() -Format "yyyy-MM-ddTHH:mm:ss"
try {
    $lastendTime = Get-Content -Path $lastendTimePath -ErrorAction SilentlyContinue
} catch {
    write-host "No last endtime file found at $lastendTimePath"
    $lastendTime = $null
}
if($lastendTime){
    $startTimeString = $lastendTime
} else {
    $startTime = ($endTime.ToUniversalTime()).AddDays(-1)
    $startTimeString = Get-Date $startTime -Format "yyyy-MM-ddTHH:mm:ss"
}

write-host "Retrieving log entries from blob content created between $startTimeString and $endTimeString"

$Entries = Get-AuditLogEntries -tenantId $tenantId -AccessToken $AccessToken -startTime $startTimeString -endTime $endTimeString
$PowerBIEntries = $Entries | sort CreationTime | Where-Object{$_.Workload -like "PowerBI"} | Select-Object CreationTime, UserId, Operation, Workload, Activity, ReportName, WorkspaceName, DatasetName, DashboardName
Push-ResultsToPowerBI -powerBiEndpoint $powerBiEndpoint -PowerBIEntries $PowerBIEntries
if($passThru){ $PowerBIEntries }

write-host "Writing current endTime: $($endTimeString), to file: $($lastendTimePath) for retrieval next run"
$endTimeString | Set-Content -Path $lastendTimePath -Force
