output "app_public_ip" {
  value = aws_eip.app.public_ip
}

output "monitoring_public_ip" {
  value = aws_eip.monitoring.public_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}

output "monitoring_private_ip" {
  value = aws_instance.monitoring.private_ip
}
