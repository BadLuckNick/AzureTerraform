resource "azurerm_policy_definition" "eventgridtopicprivatelink" {
  name         = "EventGrid-topic-PrivateLink"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Audit Event Grid topics for Private Link"

  metadata     = <<METADATA
    {
    "category": "PrivateLink"
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
