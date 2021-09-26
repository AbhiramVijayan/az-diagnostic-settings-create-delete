
$Subscriptionid = Read-Host "Enter Subscription ID"
Write-Output "1: Enable 
2: Delete "
$Number = Read-Host "Select... "
$Name = Read-Host "Enter name eg: KeyVault-Diagnostics"

$Resources = Get-AzResource | Select-Object ResourceId

switch ($Number) {
  1 { 



    foreach ($Resource in $Resources) {
      az monitor diagnostic-settings create  `
        --name  $Name `
        --resource $Resource.ResourceId `
        --metrics '[{""category"": ""AllMetrics"",""enabled"": true}]' `
        --event-hub-rule /subscriptions/$Subscriptionid/resourceGroups/deleteme/providers/Microsoft.EventHub/namespaces/adfhub/authorizationrules/RootManageSharedAccessKey

    }
  }
  2 {


    foreach ($Resource in $Resources) {
      az monitor diagnostic-settings delete  `
        --name $Name `
        --resource $Resource.ResourceId `

    }
  }
}
