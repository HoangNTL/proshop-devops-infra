output "app_public_ip" {
  value = module.compute.app_public_ip
}

output "monitoring_public_ip" {
  value = module.compute.monitoring_public_ip
}

output "app_private_ip" {
  value = module.compute.app_private_ip
}

output "monitoring_private_ip" {
  value = module.compute.monitoring_private_ip
}
