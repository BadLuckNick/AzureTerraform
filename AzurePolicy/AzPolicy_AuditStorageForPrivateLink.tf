# Configure the Microsoft Azure Provider.
provider "azurerm" {
    version = "=1.30.0"
}

# Define Azure Policy Definition
resource "azurerm_policy_definition" "storagepolicy" {
  name         = "StorageAccount-PrivateLink"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Audit storage accounts for Private Link 3"

  metadata     = <<METADATA
    {
    "category": "PrivateLink"
    }
  METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "field": "type",
        "equals": "Microsoft.Storage/storageAccounts"
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Storage/storageAccounts/privateEndpointConnections",
          "existenceCondition": {
            "field": "Microsoft.Storage/storageAccounts/privateEndpointConnections/privateLinkServiceConnectionState.status",
            "equals": "Approved"
          }
        }
      }
    }
POLICY_RULE

  parameters = <<PARAMETERS
    {
		"effect":{
			"type": "String",
			"metadata":{
				"displayName": "Effect",
				"description": "Enable or disable the execution of the policy"
			},
        "allowedValues": [
          "AuditIfNotExists",
          "Disabled"
        ],
        "defaultValue": "AuditIfNotExists"
      }
		}
PARAMETERS
}
