.PHONY: init-dev plan-dev apply-dev destroy-dev

# Variables
DEV_DIR = environments/dev

# Comandos para el entorno de desarrollo
init-dev:
	cd $(DEV_DIR) && terraform init

plan-dev:
	cd $(DEV_DIR) && terraform plan

apply-dev:
	cd $(DEV_DIR) && terraform apply

destroy-dev:
	cd $(DEV_DIR) && terraform destroy

# Ayuda
help:
	@echo "Comandos disponibles:"
	@echo "  make init-dev    - Inicializar Terraform en entorno de desarrollo"
	@echo "  make plan-dev    - Mostrar plan de despliegue para entorno de desarrollo"
	@echo "  make apply-dev   - Aplicar cambios en entorno de desarrollo"
	@echo "  make destroy-dev - Destruir recursos en entorno de desarrollo"

# Comando por defecto
default: help 