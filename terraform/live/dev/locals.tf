locals {
  common_tags = {
    Project     = "proshop"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}