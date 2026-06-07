output "app_node_public_ip" {
  value = aws_eip.app_eip.public_ip
}

output "app_node_private_ip" {
  value = aws_instance.app_node.private_ip
}

output "monitoring_node_public_ip" {
  value = aws_eip.monitoring_eip.public_ip
}

output "monitoring_node_private_ip" {
  value = aws_instance.monitoring_node.private_ip
}
