# Terraform Deployment Guide

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

## 3. Initialize Terraform

```bash
cd terraform

terraform init
```

---

## 4. Validate Configuration

```bash
terraform validate
```

---

## 5. Preview Infrastructure

```bash
terraform plan
```

---

## 6. Deploy Infrastructure

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
- Elastic IP

---

## 7. Get Outputs

```bash
terraform output
```

Example:

```text
app_node_public_ip
monitoring_node_public_ip
```

---

## 8. Destroy Infrastructure

```bash
terraform destroy
```

---

# Architecture

```text
Internet
   │
Elastic IP
   │
App Node
 ├── Nginx
 ├── Frontend
 ├── Backend
 ├── MongoDB
 ├── Node Exporter
 └── Promtail

Monitoring Node
 ├── Prometheus
 ├── Grafana
 ├── Loki
 └── AlertManager
```