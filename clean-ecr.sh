#!/usr/bin/env bash
# Clean up ECR resources
set -euo pipefail

# Load configuration
source ./config.sh

CONTAINER_NAME="ci-lab-app-test"

echo "[ECR] Stopping and removing test container..."
docker stop "$CONTAINER_NAME" 2>/dev/null || true
docker rm "$CONTAINER_NAME" 2>/dev/null || true

echo "[ECR] Removing local images..."
docker rmi "$ECR_REPOSITORY_NAME:$IMAGE_TAG" 2>/dev/null || true
docker rmi "$ECR_REGISTRY/$ECR_REPOSITORY_NAME:$IMAGE_TAG" 2>/dev/null || true

echo "[ECR] Checking if repository exists..."
if awscmd ecr describe-repositories --repository-names "$ECR_REPOSITORY_NAME" >/dev/null 2>&1; then
  echo "[ECR] Deleting ECR repository (including all images)..."
  awscmd ecr delete-repository --repository-name "$ECR_REPOSITORY_NAME" --force
  echo "[ECR] Repository deleted successfully."
else
  echo "[ECR] Repository does not exist. Nothing to delete."
fi

echo ""
echo "========================================="
echo "ECR Cleanup Complete!"
echo "========================================="
echo ""
