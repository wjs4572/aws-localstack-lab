#!/usr/bin/env bash
# Project Configuration
# Source this file in other scripts: source ./config.sh

# Build Configuration
export BUILD_DIR="build"
export ARTIFACT_NAME="app.zip"
export APP_DIR="app"

# AWS Configuration
export AWS_REGION="us-east-1"
export AWS_PROFILE="localstack"
export LOCALSTACK_ENDPOINT="http://localhost:4566"

# Project Configuration
export PROJECT_NAME="ci-lab"

# IAM Configuration
export IAM_USER="ci-pipeline-user"
export IAM_POLICY_NAME="CIPipelinePolicy"
export IAM_POLICY_FILE="policies/ci-pipeline-policy.json"

# Helper function for awslocal
awslocal() {
   aws --endpoint-url="$LOCALSTACK_ENDPOINT" --profile "$AWS_PROFILE" "$@"
}

# Export the function so it's available in scripts that source this
export -f awslocal
