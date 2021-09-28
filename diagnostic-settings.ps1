Connect-AzAccount

$Subscriptionid =  Read-Host "Enter Subscription ID"
Set-AzContext -SubscriptionId $Subscriptionid
Write-Output "1: Enable 
2: Delete "
$Number = Read-Host "Select... "

$Resources = Get-AzResource  
$Name = "KeyVault-Diagnostics"   #Read-Host "Enter name eg: KeyVault-Diagnostics"
$Eventhub = "adfhub" #Read-Host "Enter event hub name "
$resourceGroupname = "deleteme"  #Read-Host "Enter Resource group name"

switch ($Number) {
  1 { 
    # $Name = "KeyVault-Diagnostics"   #Read-Host "Enter name eg: KeyVault-Diagnostics"
    # $Eventhub = "adfhub" #Read-Host "Enter event hub name "
    # $resourceGroupname = "deleteme"  #Read-Host "Enter Resource group name"
    foreach ($Resource in $Resources) {
      if ($Resource.Location -eq "eastus") {
     

        #for storage account 
        if ( $Resource.ResourceType -eq "Microsoft.Storage/storageAccounts") {
        
          $Ids = @($Resource.ResourceId + "/blobServices/default"
            $Resource.ResourceId + "/fileServices/default"
            $Resource.ResourceId + "/queueServices/default"
            $Resource.ResourceId + "/tableServices/default"
          )
          $Ids | ForEach-Object {
            Set-AzDiagnosticSetting -ResourceId $_ -EventHubName $Name -EventHubAuthorizationRuleId "/subscriptions/$Subscriptionid/resourceGroups/$resourceGroupname/providers/Microsoft.EventHub/namespaces/$Eventhub/authorizationrules/RootManageSharedAccessKey" -Enabled $true

          
          }
        
          az monitor diagnostic-settings create  `
            --name  $Name `
            --resource $Resource.ResourceId `
            --metrics '[{""category"": ""Transaction"",""enabled"": true}]' `
            --event-hub-rule /subscriptions/$Subscriptionid/resourceGroups/$resourceGroupname/providers/Microsoft.EventHub/namespaces/$Eventhub/authorizationrules/RootManageSharedAccessKey
  
          # --logs '[{""category"": ""StorageRead"",""enabled"": true},{""category"": ""StorageWrite"",""enabled"": true},{""category"": ""StorageDelete"",""enabled"": true}]' `
          # --metrics '[{""category"": ""Transaction"",""enabled"": true}]' `
        
        }

        else {
          Set-AzDiagnosticSetting -ResourceId $Resource.ResourceId -EventHubName $Name -EventHubAuthorizationRuleId "/subscriptions/$Subscriptionid/resourceGroups/$resourceGroupname/providers/Microsoft.EventHub/namespaces/$Eventhub/authorizationrules/RootManageSharedAccessKey" -Enabled $true
       
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

    # $Name = Read-Host "Enter name eg: KeyVault-Diagnostics"
    $Name = "KeyVault-Diagnostics"
    foreach ($Resource in $Resources) {
      if ($Resource.Location -eq "eastus") {
        if ( $Resource.ResourceType -eq "Microsoft.Storage/storageAccounts") {
          $Ids = @($Resource.ResourceId + "/blobServices/default"
            $Resource.ResourceId + "/fileServices/default"
            $Resource.ResourceId + "/queueServices/default"
            $Resource.ResourceId + "/tableServices/default"
          )
          $Ids | ForEach-Object {
            # az monitor diagnostic-settings delete  `
            #   --name $Name `
            #   --resource $_ `

            Set-AzDiagnosticSetting -ResourceId $_ -EventHubName $Name -EventHubAuthorizationRuleId "/subscriptions/$Subscriptionid/resourceGroups/$resourceGroupname/providers/Microsoft.EventHub/namespaces/$Eventhub/authorizationrules/RootManageSharedAccessKey" -Enabled $false

  
          }

        }
        else {
          Set-AzDiagnosticSetting -ResourceId $Resource.ResourceId -EventHubName $Name -EventHubAuthorizationRuleId "/subscriptions/$Subscriptionid/resourceGroups/$resourceGroupname/providers/Microsoft.EventHub/namespaces/$Eventhub/authorizationrules/RootManageSharedAccessKey" -Enabled $false
          az monitor diagnostic-settings delete  `
            --name $Name `
            --resource Resource.ResourceId `

        }
    
      }
     
    }
    
  }
}

