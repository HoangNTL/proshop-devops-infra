# =========================
# DEFAULT VPC
# =========================

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "proshop-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/25"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "proshop-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "proshop-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "proshop-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

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
# SECURITY GROUP APP NODE
# =========================

resource "aws_security_group" "app_sg" {

  name        = "proshop-app-sg"
  description = "Security group for app node"

  vpc_id = aws_vpc.main.id

  # SSH
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [var.my_ip]
  }

  # HTTP
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "proshop-app-sg"
  }
}

# =========================
# SECURITY GROUP MONITORING
# =========================

resource "aws_security_group" "monitoring_sg" {

  name        = "proshop-monitoring-sg"
  description = "Security group for monitoring node"

  vpc_id = aws_vpc.main.id

  # SSH
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [var.my_ip]
  }

  # Grafana
  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"

    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "proshop-monitoring-sg"
  }
}

resource "aws_security_group_rule" "monitoring_to_app_node_exporter" {
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9100
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.monitoring_sg.id
  description              = "Allow Prometheus on monitoring node to scrape Node Exporter"
}

resource "aws_security_group_rule" "app_to_monitoring_loki" {
  type                     = "ingress"
  from_port                = 3100
  to_port                  = 3100
  protocol                 = "tcp"
  security_group_id        = aws_security_group.monitoring_sg.id
  source_security_group_id = aws_security_group.app_sg.id
  description              = "Allow Promtail on app node to push logs to Loki"
}

# =========================
# APP NODE
# =========================

resource "aws_instance" "app_node" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
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

resource "aws_instance" "monitoring_node" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.monitoring_sg.id
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

resource "aws_eip" "app_eip" {

  instance = aws_instance.app_node.id

  domain = "vpc"

  tags = {
    Name = "proshop-app-eip"
  }
}

resource "aws_eip" "monitoring_eip" {

  instance = aws_instance.monitoring_node.id

  domain = "vpc"

  tags = {
    Name = "proshop-monitoring-eip"
  }
}
