#!/bin/bash

APP_DOMAIN="${1:-https://your-domain.duckdns.org}"
MONITORING_IP="${2:-MONITORING_PUBLIC_IP}"

echo "===== CHECK APP WEBSITE ====="
curl -I -L "$APP_DOMAIN"

echo ""
echo "===== CHECK GRAFANA ====="
curl -I "http://$MONITORING_IP:3000"

echo ""
echo "===== CHECK PROMETHEUS ====="
curl --max-time 5 "http://$MONITORING_IP:9090/-/healthy"

echo ""
echo "===== CHECK LOKI READY ====="
# curl --max-time 5 "http://$MONITORING_IP:3100/ready"
echo "Loki is internal-only. Verify in Grafana Explore with datasource Loki."

echo ""
echo "===== CHECK PROMETHEUS TARGETS ====="
curl -s "http://$MONITORING_IP:9090/api/v1/targets" | grep -E '"health":"up"|"health":"down"'

echo ""
echo "===== DONE ====="