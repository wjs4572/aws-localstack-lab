#!/usr/bin/env bash
# View Lambda CloudWatch logs
set -euo pipefail

# Load configuration
source ./config.sh

echo "[LAMBDA] Fetching CloudWatch logs..."
echo ""

if [ "$USE_REAL_AWS" = "true" ]; then
    echo "=== Python Lambda Logs ==="
    awscmd logs tail /aws/lambda/hello-python --since 5m --format short
    
    echo ""
    echo "=== Java Lambda Logs ==="
    awscmd logs tail /aws/lambda/hello-java --since 5m --format short
else
    echo "⚠️  CloudWatch logs viewing works best with real AWS."
    echo "LocalStack Community has limited CloudWatch support."
    echo ""
    echo "To view logs in LocalStack, check LocalStack container logs:"
    echo "  docker logs localstack"
fi
