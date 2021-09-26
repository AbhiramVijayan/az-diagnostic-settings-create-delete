
$Subscriptionid = Read-Host "Enter Subscription ID"
Write-Output "1: Enable 
2: Delete "
$Number = Read-Host "Select... "
$Name= Read-Host "Enter name eg: KeyVault-Diagnostics"

$Resources = Get-AzResource | Select-Object ResourceId

switch ($Number) {
    1 { 



        foreach ($Resource in $Resources) {
            az monitor diagnostic-settings create  `
                --name  $Name `
                --resource $Resource.ResourceId `
                --logs '[
                    {
                      "category": "WorkflowRuntime",
                      "enabled": true,
                      "retentionPolicy": {
                        "enabled": false,
                        "days": 0
                      }
                    }
                  ]'`
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

# # Get-AzResource | Select-Object Name,ResourceId |Format-Table
# $Resources = Get-AzResource | Select-Object ResourceId  
# # az monitor diagnostic-settings list --resource adfhub

# foreach ($Resource in $Resources)
# {
#     az monitor diagnostic-settings delete  `
#     --name KeyVault-Diagnostics `
#     --resource $Resource.ResourceId `
#     # --event-hub-rule /subscriptions/d7d91dda-4b1c-4006-9ed0-67f5788026f3/resourceGroups/deleteme/providers/Microsoft.EventHub/namespaces/adfhub/authorizationrules/RootManageSharedAccessKey
#     # az monitor diagnostic-settings delete --name KeyVault-Diagnostics --resource $Resource

# }



# --metrics '[{""category"": ""AllMetrics"",""enabled"": true}]' `
# 