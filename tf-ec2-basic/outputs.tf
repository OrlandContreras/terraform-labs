# Información de la instancia (VM) EC2
# Nombre de la instancia creada
output "my-tflab-ec2-name" {
  value = aws_instance.my-tflab-ec2.id
}

# IP pública de la instancia creada
output "my-tflab-ec2-public-ip" {
  value = aws_instance.my-tflab-ec2.public_ip
}
