#!/bin/bash

MODE="${1:-load}"

TARGET_URL="${2:-https://your-domain.duckdns.org/}"
REQUESTS="${3:-1000}"
CONCURRENCY="${4:-50}"

APP_SERVER="${5:-ubuntu@APP_PUBLIC_IP}"
SSH_KEY="${6:-/home/hoangntl/my-aws-key-lab2.pem}"

echo "===== INCIDENT SIMULATION ====="
echo "Mode: $MODE"

if [ "$MODE" = "load" ]; then

    echo "===== HTTP LOAD TEST ====="
    echo "Target: $TARGET_URL"
    echo "Requests: $REQUESTS"
    echo "Concurrency: $CONCURRENCY"

    if ! command -v ab &> /dev/null
    then
        echo "apache benchmark not found"
        echo "Install:"
        echo "sudo apt install apache2-utils -y"
        exit 1
    fi

    ab -n "$REQUESTS" -c "$CONCURRENCY" "$TARGET_URL"

elif [ "$MODE" = "cpu" ]; then

    echo "===== CPU STRESS TEST ====="
    echo "Server: $APP_SERVER"

    ssh -o StrictHostKeyChecking=no \
        -i "$SSH_KEY" \
        "$APP_SERVER" \
        "sudo apt install stress -y && stress --cpu 8 --timeout 120"

else

    echo "Unknown mode"
    echo ""
    echo "Usage:"
    echo "./scripts/test-load.sh load https://domain 1000 50"
    echo "./scripts/test-load.sh cpu https://domain 1000 50 ubuntu@IP"

fi

echo "===== TEST DONE ====="