# AWS Region
variable "aws_region" {
  description = "Region where deploying resources"
  type        = string
  # default     = "us-east-1"
}

# VPC IP: cird_block
variable "vpc_ip" {
  description = "IP of VPC"
  type        = string
  default     = "172.16.0.0/16"
}

# Subnet IP: cird_block
variable "subnet_ip" {
  description = "IP of Subnet"
  type        = string
  default     = "172.16.10.0/24"
}

# Subnet Availability Zone
variable "subnet_availability_zone" {
  description = "Availability Zone of Subnet"
  type        = string
  # default     = "us-east-1a"
}

variable "allow_tls_http_cird_block" {
  description = "IP cird_block allowed"
  type        = string
  default     = "0.0.0.0/0"
}

# Port allowed for ingress rule
variable "http_port" {
  description = "Port allowed for ingress rule"
  type        = number
  # default     = 80
}

variable "my_ip" {
  description = "My IP address"
  type        = string
  default     = "xxx.xxx.xxx.xxx/32" # Debes parametrizar TU IP.
}

# Port allowed for ingress rule
variable "ssh_port" {
  description = "SSH port"
  type        = number
  # default     = 22
}

variable "ami_instance" {
  description = "AMI Instance"
  type        = string
  # default     = "ami-01816d07b1128cd2d"
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  # default     = "t2.micro"
}

locals {
  common_tags = {
    environment = "tf_lab"
  }
}
