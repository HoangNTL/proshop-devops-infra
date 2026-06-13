# Terraform Deployment Guide

## Remote State Overview

Terraform remote state moves the `terraform.tfstate` file out of the local workstation and into an S3 bucket.

That gives you:

- shared state for anyone working on the stack
- durable state storage that is not tied to a laptop
- S3 version history for rollback
- DynamoDB-based locking to prevent two applies from writing at the same time

For this repository, the recommended design is:

- S3 for state storage
- DynamoDB for lock coordination
- SSE-S3 for encryption at rest to stay close to AWS Free Tier
- S3 versioning enabled
- bucket public access blocked

## 1. Configure AWS CLI

```bash
aws configure
```

Input:

- AWS Access Key
- AWS Secret Key
- Region: `ap-southeast-1`
- Output format: `json`

---

## 2. Configure Variables

Copy example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit file:

```bash
nano terraform.tfvars
```

Example:

```hcl
aws_region   = "ap-southeast-1"

instance_type = "t3.small"

key_name = "proshop-key"

my_ip = "YOUR_PUBLIC_IP/32"
```

Get your public IP:

```bash
curl ifconfig.me
```

---

## 3. Bootstrap Remote State Resources

Create the S3 bucket and DynamoDB table from the bootstrap stack:

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

Terraform will create:

- S3 bucket for remote state
- DynamoDB table for state locking
- S3 versioning
- S3 encryption
- S3 public access block

## 4. Configure the Root Backend

Copy the example backend config:

```bash
cd ..
cp backend.hcl.example backend.hcl
```

Edit `backend.hcl` so the bucket and lock table names match the bootstrap outputs.

Then initialize the root stack with migration enabled:

```bash
terraform init -backend-config=backend.hcl -migrate-state
```

## 5. Initialize Terraform

```bash
terraform init
```

---

## 6. Validate Configuration

```bash
terraform validate
```

---

## 7. Preview Infrastructure

```bash
terraform plan
```

---

## 8. Deploy Infrastructure

```bash
terraform apply
```

Type:

```text
yes
```

Terraform will create:

- VPC
- Public Subnet
- Internet Gateway
- Security Groups
- App Node EC2
- Monitoring Node EC2
- App Node Elastic IP
- Monitoring Node Elastic IP

---

## 9. Get Outputs

```bash
terraform output
```

Example:

```text
app_node_public_ip
monitoring_node_public_ip
app_node_private_ip
monitoring_node_private_ip
```

---

## 10. Destroy Infrastructure

```bash
terraform destroy
```

---

# Architecture

```text
Internet
   ├── App Node Elastic IP
   │    └── App Node
   │         ├── Nginx
   │         ├── Frontend
   │         ├── Backend
   │         ├── MongoDB
   │         ├── Node Exporter
   │         └── Promtail
   │
   └── Monitoring Node Elastic IP
        └── Monitoring Node
             ├── Prometheus
             ├── Grafana
             ├── Loki
             └── AlertManager
```

## Remote State Migration Notes

If you are converting an existing local state to S3:

1. Create the bootstrap resources first.
2. Copy `backend.hcl.example` to `backend.hcl`.
3. Run `terraform init -migrate-state` from the root `terraform/` directory.
4. Confirm the state file is now stored in S3.
5. Keep the bootstrap stack and backend config under version control, but do not commit secrets.

## Security Notes

- App Node public access: `80`, `443`
- App Node private monitoring access: `9100` from Monitoring Node only
- Monitoring Node public access: `22`, `3000`
- Monitoring Node private logging access: `3100` from App Node only
