resource "azurerm_policy_definition" "eventgriddomainprivatelink" {
  name         = "${var.prefix}EventGrid-domain-PrivateLink"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "${var.prefix}Audit Event Grid Domains for Private Link"

  metadata     = <<METADATA
    {
    "category": "${var.category}"
    }
  METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "field": "type",
        "equals": "Microsoft.EventGrid/domains"
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.EventGrid/domains/privateEndpointConnections",
          "existenceCondition": {
            "field": "Microsoft.EventGrid/domains/privateEndpointConnections/privateLinkServiceConnectionState.status",
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
