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
  region = var.aws_region
}

data "local_file" "agent_config" {
  filename = "${path.module}/../../config/agent_config.yaml"
}

locals {
  agent_config = yamldecode(data.local_file.agent_config.content)
}

module "bedrock_agent" {
  source = "../../modules/bedrock-agent"

  foundation_model_id = local.agent_config.foundation_model.model_id
  instruction         = local.agent_config.instruction
  description         = local.agent_config.description
  collaboration_mode  = local.agent_config.collaboration_mode

  # Valores opcionales que pueden ser sobrescritos
  agent_name_prefix = var.agent_name_prefix
  idle_session_ttl  = var.idle_session_ttl
}
