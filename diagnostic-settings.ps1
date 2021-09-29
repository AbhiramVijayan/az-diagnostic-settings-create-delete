
$Subscriptionid = Read-Host "Enter Subscription ID  "
Connect-AzAccount

Set-AzContext -SubscriptionId $Subscriptionid
Write-Output "1: Enable 
2: Delete "
$Number = Read-Host "Select... "

$Resources = Get-AzResource 
$Eventhub = Read-Host "Enter Event Hub namespace name  "
$Name = Read-Host "Enter Event Hub name  "
$resourceGroupname = Read-Host "Enter Resource group name  "
$Region = Read-Host "Enter Event Hub region "
$Region = $Region -replace '\s', ''
$RegionLower = $Region.ToLower()
switch ($Number) {
  1 { 
 
    foreach ($Resource in $Resources) {
      if ($Resource.Location -eq $RegionLower) {

        # for other services 
        Set-AzDiagnosticSetting -ResourceId $Resource.ResourceId -EventHubName $Name -EventHubAuthorizationRuleId "/subscriptions/$Subscriptionid/resourceGroups/$resourceGroupname/providers/Microsoft.EventHub/namespaces/$Eventhub/authorizationrules/RootManageSharedAccessKey" -Enabled $true -EnableLog $true -EnableMetrics $true
       

    
        if ( $Resource.ResourceType -eq "Microsoft.Storage/storageAccounts") {
          #for  blob,queue,table and file
          $Ids = @($Resource.ResourceId + "/blobServices/default"
            $Resource.ResourceId + "/fileServices/default"
            $Resource.ResourceId + "/queueServices/default"
            $Resource.ResourceId + "/tableServices/default"
          )
          $Ids | ForEach-Object {
            
            Set-AzDiagnosticSetting -ResourceId $_ -EventHubName $Name -EventHubAuthorizationRuleId "/subscriptions/$Subscriptionid/resourceGroups/$resourceGroupname/providers/Microsoft.EventHub/namespaces/$Eventhub/authorizationrules/RootManageSharedAccessKey" -Enabled $true -EnableLog $true -EnableMetrics $true

          
          }
          #for  Storage account
          az monitor diagnostic-settings create  `
            --name  $Name `
            --resource $Resource.ResourceId `
            --metrics '[{""category"": ""AllMetrics"",""enabled"": true}]' `
            --event-hub-rule /subscriptions/$Subscriptionid/resourceGroups/$resourceGroupname/providers/Microsoft.EventHub/namespaces/$Eventhub/authorizationrules/RootManageSharedAccessKey

        }
       
      }
    }

  
  }
  2 {

    foreach ($Resource in $Resources) {
      if ($Resource.Location -eq $RegionLower) {

        # for other services 

        Set-AzDiagnosticSetting -ResourceId $Resource.ResourceId -EventHubName $Name -EventHubAuthorizationRuleId "/subscriptions/$Subscriptionid/resourceGroups/$resourceGroupname/providers/Microsoft.EventHub/namespaces/$Eventhub/authorizationrules/RootManageSharedAccessKey" -Enabled $false -EnableLog $false -EnableMetrics $false
 
        if ( $Resource.ResourceType -eq "Microsoft.Storage/storageAccounts") {
          #for  blob,queue,table and file

          $Ids = @($Resource.ResourceId + "/blobServices/default"
            $Resource.ResourceId + "/fileServices/default"
            $Resource.ResourceId + "/queueServices/default"
            $Resource.ResourceId + "/tableServices/default"
          )
          $Ids | ForEach-Object {
         

            Set-AzDiagnosticSetting -ResourceId $_ -EventHubName $Name -EventHubAuthorizationRuleId "/subscriptions/$Subscriptionid/resourceGroups/$resourceGroupname/providers/Microsoft.EventHub/namespaces/$Eventhub/authorizationrules/RootManageSharedAccessKey" -Enabled $false -EnableLog $false -EnableMetrics $false
  
          }
          #for  Storage account
          az monitor diagnostic-settings delete  `
            --name  $Name `
            --resource $Resource.ResourceId 
        }

      
    
      }
     
    }
    
  }
}

