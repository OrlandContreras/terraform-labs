variable "agent_name_prefix" {
  description = "Prefijo para el nombre del agente de Bedrock"
  type        = string
  default     = "bedrock-agent-demo"
}

variable "idle_session_ttl" {
  description = "Tiempo de vida de la sesión inactiva en segundos"
  type        = number
  default     = 500
}

variable "foundation_model_id" {
  description = "ID del modelo de fundación a utilizar"
  type        = string
}

variable "collaboration_mode" {
  description = "Modo de colaboración para el agente"
  type        = string
  default     = "DISABLED"
}

variable "instruction" {
  description = "Instrucciones para el agente de Bedrock"
  type        = string
}

variable "description" {
  description = "Descripción del agente de Bedrock"
  type        = string
  default     = "Agente Bedrock para demostraciones"
}
