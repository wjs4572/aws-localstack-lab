#!/usr/bin/env bash
set -euo pipefail

awslocal() {
   aws --endpoint-url=http://localhost:4566 --profile localstack "$@"
}


if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <environment>"
  echo "Example: $0 dev"
  exit 1
fi

ENVIRONMENT="$1"
BUILD_DIR="build"
ARTIFACT_NAME="app.zip"

BUCKET_NAME="ci-lab-${ENVIRONMENT}-bucket"
OBJECT_KEY="artifacts/${ENVIRONMENT}/app-$(date +%Y%m%d-%H%M%S).zip"

echo "[DEPLOY] Environment: $ENVIRONMENT"
echo "[DEPLOY] Bucket: s3://$BUCKET_NAME"
echo "[DEPLOY] Object key: $OBJECT_KEY"

if [[ ! -f "$BUILD_DIR/$ARTIFACT_NAME" ]]; then
  echo "[DEPLOY] ERROR: Artifact $BUILD_DIR/$ARTIFACT_NAME not found."
  exit 1
fi

if ! awslocal s3 ls "s3://$BUCKET_NAME" >/dev/null 2>&1; then
  echo "[DEPLOY] Bucket does not exist. Creating..."
  awslocal s3 mb "s3://$BUCKET_NAME"
else
  echo "[DEPLOY] Bucket already exists."
fi

echo "[DEPLOY] Uploading artifact to S3..."
awslocal s3 cp "$BUILD_DIR/$ARTIFACT_NAME" "s3://$BUCKET_NAME/$OBJECT_KEY"

echo "[DEPLOY] Listing bucket contents:"
awslocal s3 ls "s3://$BUCKET_NAME/"

echo "[DEPLOY] Deploy complete."
