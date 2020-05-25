resource "azurerm_policy_definition" "eventgridtopicprivatelink" {
  name         = "${var.prefix}EventGrid-topic-PrivateLink"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "${var.prefix}Audit Event Grid Topics for Private Link"

  metadata     = <<METADATA
    {
    "category": "${var.category}"
    }
  METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "field": "type",
        "equals": "Microsoft.EventGrid/topics"
      },
      "then": {
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.EventGrid/topics/privateEndpointConnections",
          "existenceCondition": {
            "field": "Microsoft.EventGrid/topics/privateEndpointConnections/privateLinkServiceConnectionState.status",
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
