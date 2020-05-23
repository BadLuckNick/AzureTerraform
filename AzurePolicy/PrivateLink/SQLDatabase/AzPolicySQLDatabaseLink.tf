resource "azurerm_policy_definition" "Sqlprivatelink" {
  name         = "Sql-PrivateLink"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Audit Sql for Private Link usage"

  metadata     = <<METADATA
    {
    "category": "PrivateLink"
    }
  METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "field": "type",
        "equals": "Microsoft.Sql/servers"
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Sql/servers/privateEndpointConnections",
          "existenceCondition": {
            "field": "Microsoft.Sql/servers/privateEndpointConnections/privateLinkServiceConnectionState.status",
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
