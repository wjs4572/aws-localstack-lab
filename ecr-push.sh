#!/usr/bin/env bash
# Build Docker image and push to ECR
set -euo pipefail

# Load configuration
source ./config.sh

echo "[ECR] Building Docker image..."
docker build -t "$ECR_REPOSITORY_NAME:$IMAGE_TAG" .

echo "[ECR] Tagging image for ECR..."
FULL_IMAGE_URI="$ECR_REGISTRY/$ECR_REPOSITORY_NAME:$IMAGE_TAG"
docker tag "$ECR_REPOSITORY_NAME:$IMAGE_TAG" "$FULL_IMAGE_URI"

echo "[ECR] Logging in to ECR..."
awscmd ecr get-login-password | docker login --username AWS --password-stdin "$ECR_REGISTRY"

echo "[ECR] Pushing image to ECR..."
docker push "$FULL_IMAGE_URI"

echo ""
echo "========================================="
echo "Image pushed successfully!"
echo "========================================="
echo ""
echo "Image URI: $FULL_IMAGE_URI"
echo ""
echo "To pull and run: ./ecr-pull.sh"
echo ""
