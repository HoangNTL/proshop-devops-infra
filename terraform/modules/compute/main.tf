# =========================
# UBUNTU AMI
# =========================

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# =========================
# APP NODE
# =========================

resource "aws_instance" "app" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    var.app_sg_id
  ]

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "proshop-app-node"
  }
}

# =========================
# MONITORING NODE
# =========================

resource "aws_instance" "monitoring" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    var.monitoring_sg_id
  ]

  root_block_device {
    volume_size           = 16
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "proshop-monitoring-node"
  }
}

# =========================
# ELASTIC IP
# =========================

resource "aws_eip" "app" {
  domain = "vpc"

  tags = {
    Name = "proshop-app-eip"
    Instance = "app"
  }
}

resource "aws_eip_association" "app_assoc" {
  instance_id   = aws_instance.app.id
  allocation_id = aws_eip.app.id
}

resource "aws_eip" "monitoring" {
  domain = "vpc"

  tags = {
    Name = "proshop-monitoring-eip"
    Instance = "monitoring"
  }
}

resource "aws_eip_association" "monitoring_assoc" {
  instance_id   = aws_instance.monitoring.id
  allocation_id = aws_eip.monitoring.id
}
