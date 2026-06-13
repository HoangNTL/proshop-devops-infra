# =========================
# SECURITY GROUP APP NODE
# =========================

resource "aws_security_group" "app" {

  name        = "proshop-app-sg"
  description = "Security group for app node"

  vpc_id = var.vpc_id

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

resource "aws_security_group" "monitoring" {

  name        = "proshop-monitoring-sg"
  description = "Security group for monitoring node"

  vpc_id = var.vpc_id

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
  security_group_id        = aws_security_group.app.id
  source_security_group_id = aws_security_group.monitoring.id
  description              = "Allow Prometheus on monitoring node to scrape Node Exporter"
}

resource "aws_security_group_rule" "app_to_monitoring_loki" {
  type                     = "ingress"
  from_port                = 3100
  to_port                  = 3100
  protocol                 = "tcp"
  security_group_id        = aws_security_group.monitoring.id
  source_security_group_id = aws_security_group.app.id
  description              = "Allow Promtail on app node to push logs to Loki"
}
