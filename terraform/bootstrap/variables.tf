variable "aws_region" {
  description = "AWS region for the bootstrap resources"
  type        = string
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "dev"
}

variable "name_prefix" {
  description = "Prefix used to build the bootstrap resource names"
  type        = string
  default     = "proshop"
}

variable "project_name" {
  description = "Project name used for standardized resource tags"
  type        = string
  default     = "proshop-devops-infra"
}
