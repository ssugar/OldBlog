# PowerBI Copilot on the Cheap

Leveraging the power of Azure Automation and PowerShell, you can efficiently manage your PowerBI Fabric F64 capacity without breaking the bank. This guide will walk you through the process of using an Azure Automation Runbook in conjunction with a local PowerShell script to start your Fabric F64 capacity for a set duration and then automatically stop it, ensuring you only pay for what you use.

## Prerequisites
Before we dive into the setup, ensure you have the following:
- An Azure subscription.
- PowerBI Fabric F64 capacity to manage.
- Basic knowledge of PowerShell scripting.

## Step 1: Setting Up Azure Automation Account
First, you'll need to create an Azure Automation account if you don't already have one. Here's how:
1. Sign in to the Azure portal.
2. Navigate to **Create a resource** > **Management Tools** > **Automation**.
3. Fill in the necessary details like the name, subscription, resource group, and location.
4. Click **Create** to provision your new Automation account.

## Step 2: Creating the Azure Automation Runbook
With your Automation account ready, it's time to create a Runbook:
1. In your Automation account, go to **Runbooks** and click **Create a runbook**.
2. Give your Runbook a name, select **PowerShell** as the Runbook type, and click **Create**.

Here, you'll input the PowerShell code that will start your Fabric F64 capacity. Leave the code block empty for now:

```powershell
Param
(
  [Parameter(Mandatory= $false)]
  [object]$WebhookData
)
<#
    .DESCRIPTION
        A Runbook for Starting and Stopping a Fabric Capicity using the Managed Identity
 
    .NOTES
        ORIGINAL AUTHOR: Richard Mintz
        LASTEDIT: Nov. 15, 2023
        UPDATE AUTHOR: Scott Sugar
        UPDATED: May. 1, 2024
#>

$subscription = ""
$resourceGroup = ""
$capacity = ""
$apiVersion = "2022-07-01-preview"

$minutesToRun = ($WebhookData.RequestBody | ConvertFrom-Json).minutesToRun

"Received $($minutesToRun) from the WebhookData Request Body"

"Please enable Contributor RBAC permissions on the Fabric Capacity to the system identity of this automation account. Otherwise, the runbook will not be successful"
 
try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

"Get the current status of the Capacity"
$response = Invoke-AzRestMethod -Method "GET" -Path "/subscriptions/${subscription}/resourceGroups/${resourceGroup}/providers/Microsoft.Fabric/capacities/${capacity}?api-version=${apiVersion}"
$state = ($response.Content | ConvertFrom-Json).properties.state
"Current status is: $($state)"
if ($state -eq "Active")
{
    Write-Output("${capacity} is already in an Active State")
}
elseif ($state -eq "Paused")
{
    "Capacity Paused - Resuming"
    $response = Invoke-AzRestMethod -Method "POST" -Path "/subscriptions/${subscription}/resourceGroups/${resourceGroup}/providers/Microsoft.Fabric/capacities/${capacity}/resume?api-version=${apiVersion}"
    if($response.StatusCode -eq "202")
    {
        "Resume Command Run"
    } else {
        "Resume Command Failed: $($response.StatusCode)"
        $response.Content | ConvertFrom-Json
    }
}

#Let the capacity run for desired # of minutes
$secondsToRun = $minutesToRun * 60
"Allowing capacity to run for $($minutesToRun) minutes"
Start-Sleep -Seconds $secondsToRun

"Get the current status of the Capacity"
$response = Invoke-AzRestMethod -Method "GET" -Path "/subscriptions/${subscription}/resourceGroups/${resourceGroup}/providers/Microsoft.Fabric/capacities/${capacity}?api-version=${apiVersion}"
$state = ($response.Content | ConvertFrom-Json).properties.state
"Current status is: $($state)"

#Continue attempting to pause the capacity until it is seen in a paused state - wait 30 seconds between attempts.
$x = 1
while($state -ne "Paused")
{
    "Capacity Active - Pause Attempt $($x)"
    $response = Invoke-AzRestMethod -Method "POST" -Path "/subscriptions/${subscription}/resourceGroups/${resourceGroup}/providers/Microsoft.Fabric/capacities/${capacity}/suspend?api-version=${apiVersion}"
    if($response.StatusCode -eq "202")
    {
        "Pause Command Run"
    } else {
        "Pause Command Failed: $($response.StatusCode)"
        $response.Content | ConvertFrom-Json
    }
    "Waiting 30 seconds"
    Start-Sleep -Seconds 30
    "Get the current status of the Capacity"
    $response = Invoke-AzRestMethod -Method "GET" -Path "/subscriptions/${subscription}/resourceGroups/${resourceGroup}/providers/Microsoft.Fabric/capacities/${capacity}?api-version=${apiVersion}"
    $state = ($response.Content | ConvertFrom-Json).properties.state
    "Current status is: $($state)"
    $x++
    if($state -eq "Paused")
    {
        "Capacity is paused - Exiting"
    }
}
```

## Step 3: Creating a Webhook for the Runbook
To trigger the Runbook remotely, you'll need a webhook:
1. In your Runbook, go to **Webhooks** and click **Add Webhook**.
2. Choose **Create new webhook**, give it a name, and set the expiration date.
3. Copy the webhook URL (you won't be able to retrieve it after you leave this blade).
4. Click **OK** and then **Create**.

## Step 4: Local PowerShell Script
On your local machine, you'll have a PowerShell script that calls the webhook to start the Runbook. Again, leave this code block empty:

```powershell
param (
    [Parameter()]
    [Int32]
    $minutesToRun = 5
)

$WebhookUri = ""

$Body  = @(@{ minutesToRun=$($minutesToRun)})
$Body = $Body | ConvertTo-Json

invoke-restmethod -Method POST -Uri $WebhookUri -Body $Body
```

## Step 5: Automating the Stop Procedure
Back in your Azure Automation Runbook, you'll add code to wait for the desired number of minutes before stopping the Fabric F64 capacity. This ensures you're only billed for the time used.

## Step 6: Testing and Scheduling
After setting up your Runbook and local script, test them to ensure they work as expected. Once confirmed, you can schedule the Runbook to run at specific times or intervals.

By following these steps, you can create a cost-effective solution for managing your PowerBI Fabric F64 capacity, ensuring you're only paying for the resources you need when you need them. Happy automating!
