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

# Creación de la VPC para el EC2
# tfsec:ignore:require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "my_tflab_vpc" {
  cidr_block           = var.vpc_ip
  enable_dns_hostnames = true

  tags = {
    Name = "my-tflab-vpc"
  }
}

# Creación del Internet Gateway
resource "aws_internet_gateway" "my_tflab_igw" {
  vpc_id = aws_vpc.my_tflab_vpc.id

  tags = {
    Name = "my-tflab-igw"
  }
}

# Creación de la Subnet para el EC2
resource "aws_subnet" "my_tflab_subnet" {
  vpc_id                  = aws_vpc.my_tflab_vpc.id
  cidr_block              = var.subnet_ip
  availability_zone       = var.subnet_availability_zone
  map_public_ip_on_launch = false
  depends_on              = [aws_internet_gateway.my_tflab_igw]

  tags = {
    Name = "my-tflab-subnet"
  }
}

# Creación del Security Group para el EC2
resource "aws_security_group" "my_tflab_security_group" {
  name        = "my-tflab-security-group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_tflab_vpc.id

  tags = {
    Name = "my-tflab-security-group"
  }
}

# Creación de las reglas del security group (Inbound)
# Creación de la regla HTTP
resource "aws_vpc_security_group_ingress_rule" "allow_tls_http" {
  security_group_id = aws_security_group.my_tflab_security_group.id
  cidr_ipv4         = var.allow_tls_http_cird_block
  from_port         = var.http_port
  ip_protocol       = "tcp"
  to_port           = var.http_port

  tags = {
    Name = "allow-tls-http"
  }
}

# Creación de la regla SSH
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ssh" {
  security_group_id = aws_security_group.my-tflab-security-group.id
  cidr_ipv4         = var.my_ip # Debes parametrizar TU IP en el archivo "variables.tf"
  from_port         = var.ssh_port
  ip_protocol       = "tcp"
  to_port           = var.ssh_port

  tags = {
    Name = "allow-tls-ssh"
  }
}

# Creación de las reglas del security group (Outbound)
# Creación de la regla Outbound All
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.my_tflab_security_group.id
  cidr_ipv4         = var.allow_tls_http_cird_block
  ip_protocol       = "-1"

  tags = {
    Name = "allow-all"
  }
}

# Creación de la Network Interface para el EC2
resource "aws_network_interface" "my_tflab_network_interface" {
  subnet_id = aws_subnet.my_tflab_subnet.id
  private_ips = [
    "172.16.10.10"
  ]
  # Se asocia el Security Group con las reglas Inbound / Outbound
  security_groups = [
    aws_security_group.my_tflab_security_group.id
  ]

  tags = {
    Name = "my-tflab-network-interface"
  }
}

# resource: Describe uno o mas objetos de la infraestructura
# Creación de la instancia (VM) EC2
resource "aws_instance" "my_tflab_ec2" {
  ami           = var.ami_instance
  instance_type = var.instance_type

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  # network_interface: Describe una interfaz de red de la instancia
  network_interface {
    network_interface_id = aws_network_interface.my_tflab_network_interface.id
    device_index         = 0
  }

  # Nombre de la instancia
  tags = {
    Name = "my-tflab-ec2"
  }
}

# Creación de una Elastic IP: IP pública estatica para el EC2
resource "aws_eip" "my_tflab_eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.my_tflab_network_interface.id
  associate_with_private_ip = "172.16.10.10"

  tags = {
    Name = "my-tflab-eip"
  }
}
