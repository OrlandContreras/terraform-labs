terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws" # Provider oficial mantenido por Hashicorp
      # version = "~> 5.82" # Cualquier versión en el rango 5.82
      version = "5.82.2"
    }
  }

  required_version = ">= 1.2.0"
}

# Configuración del proveedor AWS
provider "aws" {
  region = var.aws_region
}
