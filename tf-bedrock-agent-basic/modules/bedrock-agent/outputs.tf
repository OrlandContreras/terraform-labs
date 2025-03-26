output "agent_id" {
  description = "ID del agente de Bedrock creado"
  value       = aws_bedrockagent_agent.bd_agent_demo.id
}

output "agent_name" {
  description = "Nombre del agente de Bedrock creado"
  value       = aws_bedrockagent_agent.bd_agent_demo.agent_name
}

output "agent_alias_id" {
  description = "ID del alias del agente de Bedrock"
  value       = aws_bedrockagent_agent_alias.bedrock-agent-demo-alias.id
}

output "agent_role_arn" {
  description = "ARN del rol IAM asociado al agente de Bedrock"
  value       = aws_iam_role.bd_agent_iam_role.arn
}
