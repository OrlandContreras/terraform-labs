# Terraform AWS Bedrock Agent

Este proyecto implementa un agente básico de AWS Bedrock utilizando Terraform con una estructura modular y siguiendo las mejores prácticas.

## Estructura del Proyecto

```
tf-bedrock-agent-basic/
│
├── config/                  # Archivos de configuración
│   └── agent_config.yaml    # Configuración del agente (instrucciones, modelo, etc.)
│
├── modules/                 # Módulos reutilizables
│   └── bedrock-agent/       # Módulo para crear agentes de AWS Bedrock
│       ├── main.tf          # Recursos principales del módulo
│       ├── variables.tf     # Variables de entrada del módulo
│       └── outputs.tf       # Valores de salida del módulo
│
├── environments/            # Configuraciones específicas por entorno
│   └── dev/                 # Entorno de desarrollo
│       ├── main.tf          # Configuración principal para desarrollo
│       ├── variables.tf     # Variables del entorno
│       ├── outputs.tf       # Salidas del entorno
│       └── terraform.tfvars # Valores específicos para desarrollo
│
├── .gitignore               # Archivos a ignorar en el control de versiones
├── Makefile                 # Comandos para facilitar el uso de Terraform
├── main.tf                  # Archivo principal con documentación
└── README.md                # Documentación del proyecto
```

## Uso con Make

Puedes utilizar los comandos del Makefile para simplificar las operaciones:

```bash
# Inicializar Terraform en el entorno de desarrollo
make init-dev

# Ver el plan de ejecución
make plan-dev

# Aplicar los cambios
make apply-dev

# Destruir la infraestructura
make destroy-dev
```

## Uso Manual

Alternativamente, puedes navegar manualmente al directorio del entorno:

1. Navega al directorio del entorno deseado:
   ```bash
   cd environments/dev
   ```

2. Inicializa Terraform:
   ```bash
   terraform init
   ```

3. Revisa el plan de ejecución:
   ```bash
   terraform plan
   ```

4. Aplica los cambios:
   ```bash
   terraform apply
   ```

## Personalización

Para personalizar el comportamiento del agente, modifica el archivo `config/agent_config.yaml` con tus instrucciones y parámetros específicos. 