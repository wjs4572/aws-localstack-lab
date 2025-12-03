#!/usr/bin/env bash
# Pull image from ECR and run it
set -euo pipefail

# Load configuration
source ./config.sh

FULL_IMAGE_URI="$ECR_REGISTRY/$ECR_REPOSITORY_NAME:$IMAGE_TAG"
CONTAINER_NAME="ci-lab-app-test"

echo "[ECR] Logging in to ECR..."
awscmd ecr get-login-password | docker login --username AWS --password-stdin "$ECR_REGISTRY"

echo "[ECR] Pulling image from ECR..."
docker pull "$FULL_IMAGE_URI"

echo "[ECR] Stopping any existing container..."
docker stop "$CONTAINER_NAME" 2>/dev/null || true
docker rm "$CONTAINER_NAME" 2>/dev/null || true

echo "[ECR] Running container on port 8080..."
docker run -d --name "$CONTAINER_NAME" -p 8080:80 "$FULL_IMAGE_URI"

echo ""
echo "========================================="
echo "Container running!"
echo "========================================="
echo ""
echo "View app at: http://localhost:8080"
echo ""
echo "To stop container: docker stop $CONTAINER_NAME"
echo "To remove container: docker rm $CONTAINER_NAME"
echo ""
