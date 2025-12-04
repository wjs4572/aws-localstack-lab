#!/bin/bash
# Bash setup script for AWS LocalStack Lab
# Source the awslocal utilities from aws-utils repository

AWS_UTILS_PATH="D:/co/github_personal/project_aws-utils/aws-utils/scripts/awslocal.sh"

if [ -f "$AWS_UTILS_PATH" ]; then
    source "$AWS_UTILS_PATH"
    echo "✓ AWS LocalStack utilities loaded (Bash)"
else
    echo "✗ Could not find awslocal.sh at: $AWS_UTILS_PATH"
    echo "Defining awslocal function locally..."
    
    awslocal() {
        aws --endpoint-url=http://localhost:4566 --profile localstack "$@"
    }
    echo "✓ awslocal function defined locally"
fi
