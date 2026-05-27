# Ansible Setup

This folder contains Ansible playbooks for configuring App Node and Monitoring Node.

## Structure

```text
ansible/
├── inventory.ini.example
├── README.md
└── playbooks/
    ├── site.yml
    ├── common.yml
    ├── docker.yml
    └── security.yml
```

## 1. Prepare inventory

```bash
cp inventory.ini.example inventory.ini
```

Edit `inventory.ini`:

```ini
[app]
app-node ansible_host=APP_PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem

[monitoring]
monitoring-node ansible_host=MONITORING_PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem
```

## 2. Test connection

```bash
ansible all -i inventory.ini -m ping
```

## 3. Run all base setup

```bash
ansible-playbook -i inventory.ini playbooks/site.yml
```

## 4. Run specific playbook

```bash
ansible-playbook -i inventory.ini playbooks/common.yml
ansible-playbook -i inventory.ini playbooks/docker.yml
ansible-playbook -i inventory.ini playbooks/security.yml
```

## 5. Verify

```bash
ansible all -i inventory.ini -a "docker --version"
ansible all -i inventory.ini -a "docker compose version"
ansible all -i inventory.ini -a "sudo ufw status"
```
