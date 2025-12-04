#!/usr/bin/env bash
# Clean up Lambda resources
set -euo pipefail

# Load configuration
source ./config.sh

echo "[CLEAN-LAMBDA] Cleaning up Lambda resources..."

# Delete Lambda functions
echo "[CLEAN-LAMBDA] Deleting Lambda functions..."
awscmd lambda delete-function --function-name hello-python 2>/dev/null || echo "  Python function not found (already deleted?)"
awscmd lambda delete-function --function-name hello-java 2>/dev/null || echo "  Java function not found (already deleted?)"

# Delete IAM role (if using real AWS)
if [ "$USE_REAL_AWS" = "true" ]; then
    echo "[CLEAN-LAMBDA] Deleting IAM role..."
    
    ROLE_NAME="lambda-execution-role"
    
    # Detach policies
    awscmd iam detach-role-policy \
        --role-name "$ROLE_NAME" \
        --policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" \
        2>/dev/null || echo "  Policy already detached"
    
    # Delete role
    awscmd iam delete-role --role-name "$ROLE_NAME" 2>/dev/null || echo "  Role not found (already deleted?)"
fi

# Clean up local files
echo "[CLEAN-LAMBDA] Cleaning up local files..."
rm -f lambda-python.zip
rm -f response-python.json
rm -f response-java.json
rm -rf lambda-java/target

echo ""
echo "========================================="
echo "Lambda cleanup complete!"
echo "========================================="
echo ""
