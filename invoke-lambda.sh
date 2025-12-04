#!/usr/bin/env bash
# Invoke Lambda functions
set -euo pipefail

# Load configuration
source ./config.sh

echo "[LAMBDA] Invoking Lambda functions..."
echo ""

# Invoke Python Lambda
echo "=== Python Lambda ==="
awscmd lambda invoke \
    --function-name hello-python \
    --payload '{"name":"DevOps Engineer"}' \
    --cli-binary-format raw-in-base64-out \
    response-python.json

echo "Response:"
cat response-python.json | jq '.'
echo ""

# Invoke Java Lambda
echo "=== Java Lambda ==="
awscmd lambda invoke \
    --function-name hello-java \
    --payload '{"name":"Cloud Architect"}' \
    --cli-binary-format raw-in-base64-out \
    response-java.json

echo "Response:"
cat response-java.json | jq '.'
echo ""

echo "========================================="
echo "Both functions invoked successfully!"
echo "========================================="
echo ""
echo "Response files saved:"
echo "  - response-python.json"
echo "  - response-java.json"
echo ""
