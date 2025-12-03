#!/usr/bin/env bash
# Clean deployed resources from LocalStack

set -euo pipefail

# Load configuration
source ./config.sh

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <environment>"
  echo "Example: $0 dev"
  exit 1
fi

ENVIRONMENT="$1"
BUCKET_NAME="${PROJECT_NAME}-${ENVIRONMENT}-bucket"

echo "[CLEAN] Environment: $ENVIRONMENT"
echo "[CLEAN] Bucket: s3://$BUCKET_NAME"

if awslocal s3 ls "s3://$BUCKET_NAME" >/dev/null 2>&1; then
  echo "[CLEAN] Emptying bucket..."
  awslocal s3 rm "s3://$BUCKET_NAME" --recursive
  
  echo "[CLEAN] Deleting bucket..."
  awslocal s3 rb "s3://$BUCKET_NAME"
  
  echo "[CLEAN] Bucket deleted."
else
  echo "[CLEAN] Bucket does not exist. Nothing to clean."
fi

echo "[CLEAN] Cleanup complete."
