locals {
  state_bucket_name = "${var.name_prefix}-tfstate-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
  lock_table_name   = "${var.name_prefix}-tf-locks-${data.aws_caller_identity.current.account_id}-${var.aws_region}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Purpose     = "terraform-bootstrap"
  }
}
