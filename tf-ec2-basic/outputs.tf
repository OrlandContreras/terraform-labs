# Información de la instancia (VM) EC2
# Nombre de la instancia creada
output "my_tflab_ec2_name" {
  description = "EC2 name instance"
  value       = aws_instance.my_tflab_ec2.id
}

# IP pública de la instancia creada
output "my_tflab_ec2_public_ip" {
  description = "Public IP"
  value       = aws_instance.my_tflab_ec2.public_ip
}
