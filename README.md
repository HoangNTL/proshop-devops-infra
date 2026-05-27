# ProShop DevOps Infrastructure

Dự án tự động hóa triển khai hệ thống ProShop MERN trên AWS theo hướng production-ready.

## Mục tiêu

Dự án này dùng Terraform và Ansible để dựng lại toàn bộ hệ thống đã triển khai thủ công:

- AWS EC2
- Security Group
- Elastic IP
- Docker Compose
- Nginx Reverse Proxy
- HTTPS SSL
- Prometheus
- Grafana
- Loki
- Promtail
- AlertManager
- Telegram Alert

## Kiến trúc hệ thống

```text
Internet
   ↓
App Node EC2
├── Nginx HTTPS
├── Frontend React
├── Backend NodeJS
├── MongoDB
├── Node Exporter
└── Promtail

Monitoring Node EC2
├── Prometheus
├── Grafana
├── Loki
└── AlertManager
```
