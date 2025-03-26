variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "agent_name_prefix" {
  description = "Prefijo para el nombre del agente de Bedrock"
  type        = string
  default     = "bedrock-agent-dev"
}

variable "idle_session_ttl" {
  description = "Tiempo de vida de la sesión inactiva en segundos"
  type        = number
  default     = 500
}
