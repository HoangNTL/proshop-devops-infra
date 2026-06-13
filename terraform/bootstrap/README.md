# Terraform Bootstrap Stack

This folder creates the AWS resources needed for the remote backend:

- S3 bucket for Terraform state
- DynamoDB table for state locking
- S3 versioning
- S3 server-side encryption
- S3 public access blocking
- S3 lifecycle cleanup for noncurrent object versions
- Standardized tagging across bootstrap resources

Use this stack before initializing the root Terraform configuration with the S3 backend.
