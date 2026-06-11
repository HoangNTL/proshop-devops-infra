#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <monitoring-ip> <pem-file>"
    exit 1
fi

MONITORING_IP=$1
KEY_FILE=$2

ssh -o StrictHostKeyChecking=no \
-i "$KEY_FILE" \
-L 3000:localhost:3000 \
-L 9090:localhost:9090 \
-L 9093:localhost:9093 \
ubuntu@$MONITORING_IP