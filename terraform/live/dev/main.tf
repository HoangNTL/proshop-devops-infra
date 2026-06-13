module "network" {
  source = "../../modules/network"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  aws_region  = var.aws_region
}

module "security" {
  source = "../../modules/security"

  vpc_id = module.network.vpc_id
  my_ip  = var.my_ip
}

module "compute" {
  source = "../../modules/compute"

  subnet_id = module.network.public_subnet_id

  app_sg_id        = module.security.app_sg_id
  monitoring_sg_id = module.security.monitoring_sg_id

  instance_type = var.instance_type
  key_name      = var.key_name
}
