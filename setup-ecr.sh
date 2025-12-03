#!/usr/bin/env bash
# Create ECR repository for container images
set -euo pipefail

# Load configuration
source ./config.sh

echo "[ECR] Checking if repository exists: $ECR_REPOSITORY_NAME"
if awscmd ecr describe-repositories --repository-names "$ECR_REPOSITORY_NAME" >/dev/null 2>&1; then
  echo "[ECR] Repository already exists."
  REPO_URI=$(awscmd ecr describe-repositories --repository-names "$ECR_REPOSITORY_NAME" --query 'repositories[0].repositoryUri' --output text)
else
  echo "[ECR] Creating ECR repository: $ECR_REPOSITORY_NAME"
  REPO_URI=$(awscmd ecr create-repository \
    --repository-name "$ECR_REPOSITORY_NAME" \
    --query 'repository.repositoryUri' \
    --output text)
  echo "[ECR] Repository created successfully."
fi

echo ""
echo "========================================="
echo "ECR Setup Complete!"
echo "========================================="
echo ""
echo "Repository URI: $REPO_URI"
echo ""
echo "Next steps:"
echo "  1. Build and push image: ./ecr-push.sh"
echo "  2. Pull and run image: ./ecr-pull.sh"
echo ""
