#!/usr/bin/env bash
# Project Configuration
# Source this file in other scripts: source ./config.sh

# Build Configuration
export BUILD_DIR="build"
export ARTIFACT_NAME="app.zip"
export APP_DIR="app"

# ==============================================================================
# TOGGLE: Set USE_REAL_AWS=true to use real AWS, false for LocalStack
# ==============================================================================
export USE_REAL_AWS=false  # Change to 'true' to use real AWS instead of LocalStack

# AWS Configuration
export AWS_REGION="us-east-1"

if [ "$USE_REAL_AWS" = "true" ]; then
  export AWS_PROFILE="default"  # Or your AWS profile name
  export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo "YOUR_ACCOUNT_ID")
  export ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
  echo "[CONFIG] Using REAL AWS (Account: $AWS_ACCOUNT_ID)"
else
  export AWS_PROFILE="localstack"
  export LOCALSTACK_ENDPOINT="http://localhost:4566"
  export AWS_ACCOUNT_ID="000000000000"
  export ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.localhost.localstack.cloud:4566"
  echo "[CONFIG] Using LocalStack (requires Pro for ECR)"
fi

# Project Configuration
export PROJECT_NAME="ci-lab"

# IAM Configuration
export IAM_USER="ci-pipeline-user"
export IAM_POLICY_NAME="CIPipelinePolicy"
export IAM_POLICY_FILE="policies/ci-pipeline-policy.json"

# ECR Configuration
export ECR_REPOSITORY_NAME="ci-lab-app"
export IMAGE_TAG="latest"

# Helper function for AWS CLI (works with both LocalStack and real AWS)
awscmd() {
  if [ "$USE_REAL_AWS" = "true" ]; then
    aws --profile "$AWS_PROFILE" --region "$AWS_REGION" "$@"
  else
    aws --endpoint-url="$LOCALSTACK_ENDPOINT" --profile "$AWS_PROFILE" "$@"
  fi
}

# Backward compatibility alias
awslocal() {
  awscmd "$@"
}

# Export the functions so they're available in scripts that source this
export -f awscmd
export -f awslocal
