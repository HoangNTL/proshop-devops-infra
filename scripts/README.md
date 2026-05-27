# Scripts

This folder contains helper scripts for checking system status and simulating incidents.

---

## 1. Check system status

```bash
./scripts/check-status.sh https://your-domain.duckdns.org MONITORING_PUBLIC_IP
```

Example:

```bash
./scripts/check-status.sh https://dxh-cloud.duckdns.org 13.212.xxx.xxx
```

This script checks:

- App website
- Grafana
- Prometheus health
- Prometheus targets

Note:

```text
Loki is internal-only. Verify Loki logs in Grafana Explore.
```

---

## 2. HTTP load test

```bash
./scripts/test-load.sh load https://your-domain.duckdns.org/ 1000 50
```

Example:

```bash
./scripts/test-load.sh load https://dxh-cloud.duckdns.org/ 1000 50
```

Arguments:

```text
1. Mode: load
2. Target URL
3. Number of requests
4. Concurrency
```

This simulates high HTTP traffic using ApacheBench.

Install ApacheBench if needed:

```bash
sudo apt install apache2-utils -y
```

---

## 3. CPU incident simulation

```bash
./scripts/test-load.sh cpu https://your-domain.duckdns.org/ 1000 50 ubuntu@APP_PUBLIC_IP
```

Example:

```bash
./scripts/test-load.sh cpu https://dxh-cloud.duckdns.org/ 1000 50 ubuntu@13.212.xxx.xxx
```

Arguments:

```text
1. Mode: cpu
2. Target URL
3. Number of requests
4. Concurrency
5. App Node SSH user and IP
```

This script SSHs into the App Node and runs:

```bash
stress --cpu 8 --timeout 120
```

It is used to trigger CPU alerts in Prometheus and AlertManager.

---

## 4. Expected result

After running the incident simulation:

- Grafana shows CPU spike
- Prometheus alert becomes Pending/Firing
- AlertManager sends notification
- Loki/Grafana can be used to inspect logs
