#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <environment>"
  echo "Example: $0 dev"
  exit 1
fi

ENVIRONMENT="$1"

echo "====================================="
echo " CI PIPELINE START - ENV: $ENVIRONMENT"
echo "====================================="

echo "[STAGE] Build"
./build.sh

echo "[STAGE] Test"
./test.sh

echo "[STAGE] Deploy"
./deploy.sh "$ENVIRONMENT"

echo "====================================="
echo " CI PIPELINE COMPLETE - ENV: $ENVIRONMENT"
echo "====================================="
