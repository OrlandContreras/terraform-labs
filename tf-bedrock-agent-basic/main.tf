terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
  }
  required_version = ">= 1.2.0"

}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

data "local_file" "agent_config" {
  filename = "agent_config.yaml"
}

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
    resources = ["arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}::foundation-model/${local.agent_config.foundation_model.model_id}"]
  }
}

locals {
  agent_config = yamldecode(data.local_file.agent_config.content)
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
  agent_name                  = "bedrock-agent-demo-${random_pet.name.id}"
  agent_resource_role_arn     = aws_iam_role.bd_agent_iam_role.arn
  idle_session_ttl_in_seconds = 500
  foundation_model            = local.agent_config.foundation_model.model_id
  agent_collaboration         = local.agent_config.collaboration_mode
  instruction                 = local.agent_config.instruction
  description                 = local.agent_config.description
}

resource "aws_bedrockagent_agent_alias" "bedrock-agent-demo-alias" {
  agent_alias_name = "bedrock-agent-demo-alias-${random_pet.name.id}"
  agent_id         = aws_bedrockagent_agent.bd_agent_demo.id
  description      = "Alias for bedrock-agent-demo"
}
