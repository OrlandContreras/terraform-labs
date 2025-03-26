output "agent_id" {
  description = "ID del agente de Bedrock creado"
  value       = module.bedrock_agent.agent_id
}

output "agent_name" {
  description = "Nombre del agente de Bedrock creado"
  value       = module.bedrock_agent.agent_name
}

output "agent_alias_id" {
  description = "ID del alias del agente de Bedrock"
  value       = module.bedrock_agent.agent_alias_id
}

output "agent_role_arn" {
  description = "ARN del rol IAM asociado al agente de Bedrock"
  value       = module.bedrock_agent.agent_role_arn
}
