# Copilot for PowerBI on the Cheap

PowerBI Copilot offers a transformative experience for data analysis and visualization, providing users with advanced AI capabilities to enhance their Power BI usage. However, it's important to note that while Copilot can significantly boost productivity and insights, running high-capacity SKUs like the Fabric F64 capacity 24/7 can lead to substantial costs. 

Leveraging the power of Azure Automation and PowerShell, you can efficiently manage your PowerBI Fabric F64 capacity to use with Copilot for Power BI without breaking the bank. This guide will walk you through the process of using an Azure Automation Runbook in conjunction with a local PowerShell script to start your Fabric F64 capacity for a set duration and then automatically stop it, ensuring you only pay for what you use.

The goal of this guide is to allow you to run a PowerShell script on your local machine which will start your F64 capacity for a set period of time of your choosing and then stop it without further intervention.  This **should** minimize the risks associated with a human forgetting to pause the F64 SKU after they are done using Copilot for Power BI.  

Ideally this will open the door for individuals and small/medium businesses to be able to use Copilot for Power BI.

## :warning: Warning: Potential Cost Overages with F64 SKU

:warning: **Caution:** The F64 SKU of PowerBI Fabric is a high-capacity offering that can incur significant costs, potentially amounting to thousands of dollars per month. While the automation scripts provided in this blog aim to help manage and minimize these costs, they are not infallible.

:warning: **Use at Your Own Risk:** The approach outlined in this blog, including the Azure Automation Runbook and local PowerShell script, requires careful implementation and constant monitoring to avoid unintended charges. It is crucial to ensure that the scripts are functioning correctly and that the Fabric F64 capacity is not running longer than necessary.

**Recommendations:**
- Regularly review the Azure Automation Runbook's execution history to confirm that it starts and stops the capacity as expected.
- Monitor your Azure billing closely to detect any anomalies or unexpected charges.
- Consider implementing additional safeguards, such as budget alerts in Azure, to receive notifications when your spending approaches a predefined threshold.

:warning: **Disclaimer:** The author of this blog and the code provided herein are not responsible for any financial impact related to the use of these scripts. Extreme caution is advised when automating the management of your Fabric F64 capacity. Always test thoroughly in a non-production environment before implementing in a live setting.

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

Here, you'll input the PowerShell code that will start and stop your Fabric F64 capacity.  Note the need to fill in the subscription, resourceGroup and capacity variables in the code below

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

## Step 3: Grant Contributor access to your Fabric Capacity for your Azure Automation account Managed Identity
1. Navigate to your Fabric Capacity resource.
2. Go to Access Control (IAM).
3. Click on Add a role assignment.
4. In the Role field, select Contributor.
5. In the Assign access to field, select Managed Identity.
6. Select the appropriate managed identity associated with your Azure Automation account.
7. Click Save to apply the changes.

## Step 4: Creating a Webhook for the Runbook
To trigger the Runbook remotely, you'll need a webhook:
1. In your Runbook, go to **Webhooks** and click **Add Webhook**.
2. Choose **Create new webhook**, give it a name, and set the expiration date.
3. Copy the webhook URL (you won't be able to retrieve it after you leave this blade).
4. Click **OK** and then **Create**.

## Step 5: Local PowerShell Script
On your local machine, you'll have a PowerShell script that calls the webhook to start the Runbook.  Note the need to fill in the WebhookUri variable in the code below.  This Uri will come from Step 4.3 above.

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

## Step 6: Testing
After setting up your Runbook and local script, test them to ensure they work as expected.  You can run the local PowerShell script using the following command (assuming you save the above local powershell script code as Run-PowerBICopilotForXMinutes.ps1)

```powershell
.\Run-PowerBICopilotForXMinutes.ps1 -minutesToRun 5
```

By following these steps, you can create a cost-effective solution for managing your PowerBI Fabric F64 capacity, ensuring you're only paying for the resources you need when you need them.
