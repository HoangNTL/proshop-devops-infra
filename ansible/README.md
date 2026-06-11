# Ansible Setup

This folder contains Ansible playbooks for configuring App Node and Monitoring Node.

## Structure

```text
ansible/
├── files/
├── group_vars/
│   └── all/
│       ├── main.yml
│       ├── main.yml.example
│       ├── secrets.yml
│       └── secrets.yml.example
├── templates/
│   └── app.env.j2
├── inventory.ini.example
├── README.md
└── playbooks/
    ├── site.yml
    ├── common.yml
    ├── docker.yml
    ├── security.yml
    ├── app-node.yml
    └── monitoring-node.yml
```

---

# 1. Prepare inventory

```bash
cp inventory.ini.example inventory.ini
```

Edit `inventory.ini`:

```ini
[app]
app-node ansible_host=APP_PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem

[monitoring]
monitoring-node ansible_host=MONITORING_PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

---

# 2. Prepare variables

```bash
cp group_vars/all/main.yml.example group_vars/all/main.yml
cp group_vars/all/secrets.yml.example group_vars/all/secrets.yml
```

Edit `group_vars/all/main.yml`:

```yaml
domain_name: "your-domain.duckdns.org"
certbot_email: "admin@example.com"
admin_ip_cidr: "YOUR_PUBLIC_IP/32"

monitoring_private_ip: "MONITORING_PRIVATE_IP"
app_private_ip: "APP_PRIVATE_IP"
app_repo_url: "https://github.com/your-account/proshop_mern.git"
app_repo_branch: "master"
```

Edit `group_vars/all/secrets.yml`:

```yaml
jwt_secret: "CHANGE_ME_TO_A_LONG_RANDOM_VALUE"
paypal_client_id: "YOUR_PAYPAL_CLIENT_ID"
telegram_bot_token: "YOUR_TELEGRAM_BOT_TOKEN"
telegram_chat_id: "YOUR_TELEGRAM_CHAT_ID"
```

---

# 3. Test connection

```bash
ansible all -i inventory.ini -m ping
```

---

# 4. Run full setup

```bash
ansible-playbook -i inventory.ini playbooks/site.yml
```

---

# 5. Run specific playbook

## Base setup

```bash
ansible-playbook -i inventory.ini playbooks/common.yml
ansible-playbook -i inventory.ini playbooks/docker.yml
ansible-playbook -i inventory.ini playbooks/security.yml
```

## Monitoring Node setup

```bash
ansible-playbook -i inventory.ini playbooks/monitoring-node.yml
```

## App Node setup

```bash
ansible-playbook -i inventory.ini playbooks/app-node.yml
```

---

# 6. Verify

## Docker

```bash
ansible all -i inventory.ini -a "docker --version"
ansible all -i inventory.ini -a "docker compose version"
```

## UFW

```bash
ansible all -i inventory.ini -a "sudo ufw status"
```

## Containers

```bash
ansible all -i inventory.ini -a "docker ps"
```

## Promtail

```bash
ansible app -i inventory.ini -a "systemctl status promtail --no-pager"
```

---

# 7. Access Services

## App

```text
http://your-domain.duckdns.org
```

## Grafana

```text
http://MONITORING_PUBLIC_IP:3000
```

Default credentials:

```text
admin / admin
```

## Prometheus

```text
ssh -L 9090:localhost:9090 ubuntu@MONITORING_PUBLIC_IP
http://localhost:9090
```

---

# 8. HTTPS Setup (Automated)

After DNS is configured and propagated, the `app-node.yml` playbook will automatically:

- Request a Let's Encrypt certificate with Certbot
- Update Nginx for HTTPS
- Redirect HTTP to HTTPS
- Enable `certbot.timer` for automatic renewal

Run:

```bash
ansible-playbook -i inventory.ini playbooks/site.yml
```

## Notes

- App `.env` is generated from `templates/app.env.j2`.
- `group_vars/all/secrets.yml` is local-only and ignored by Git.
- Frontend and backend containers bind to `127.0.0.1`, so they are reachable only through Nginx on the app node.
- Monitoring node firewall allows public access only to Grafana on port `3000`.
- DNS for `domain_name` must already point to the App Node public IP before Certbot runs.
