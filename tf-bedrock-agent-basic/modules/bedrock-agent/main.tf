data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "bd_agent_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["bedrock.amazonaws.com"]
      type        = "Service"
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.current.account_id]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "ArnLike"
      values   = ["arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:agent/*"]
      variable = "AWS:SourceArn"
    }
  }
}

data "aws_iam_policy_document" "bd_agent_permissions" {
  statement {
    actions   = ["bedrock:InvokeAgent"]
    resources = ["arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}::foundation-model/${var.foundation_model_id}"]
  }
}

resource "random_pet" "name" {
  length = 1
}

resource "aws_iam_role" "bd_agent_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.bd_agent_trust.json
  name_prefix        = "AmazonBedrockExecutionRoleForAgents_"
}

resource "aws_iam_role_policy" "bd_agent_role_policy" {
  policy = data.aws_iam_policy_document.bd_agent_permissions.json
  role   = aws_iam_role.bd_agent_iam_role.id
}

resource "aws_bedrockagent_agent" "bd_agent_demo" {
  agent_name                  = "${var.agent_name_prefix}-${random_pet.name.id}"
  agent_resource_role_arn     = aws_iam_role.bd_agent_iam_role.arn
  idle_session_ttl_in_seconds = var.idle_session_ttl
  foundation_model            = var.foundation_model_id
  agent_collaboration         = var.collaboration_mode
  instruction                 = var.instruction
  description                 = var.description
}

resource "aws_bedrockagent_agent_alias" "bedrock-agent-demo-alias" {
  agent_alias_name = "${var.agent_name_prefix}-alias-${random_pet.name.id}"
  agent_id         = aws_bedrockagent_agent.bd_agent_demo.id
  description      = "Alias for ${var.agent_name_prefix}"
}
