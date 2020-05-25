resource "azurerm_policy_definition" "storageprivatelink" {
  name         = "${var.prefix}StorageAccount-PrivateLink"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "${var.prefix}Audit storage accounts for Private Link"

  metadata     = <<METADATA
    {
    "category": "${var.category}"
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
