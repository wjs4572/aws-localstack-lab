#!/usr/bin/env bash
# Create IAM user with least-privilege policy for CI/CD pipeline
set -euo pipefail

# Load configuration
source ./config.sh

USER_EXISTS=false

echo "[IAM] Checking if IAM user exists: $IAM_USER"
if awslocal iam get-user --user-name "$IAM_USER" >/dev/null 2>&1; then
  echo "[IAM] User $IAM_USER already exists."
  USER_EXISTS=true
else
  echo "[IAM] Creating IAM user: $IAM_USER"
  awslocal iam create-user --user-name "$IAM_USER"
  echo "[IAM] User created successfully."
fi

# Only create access key if user is newly created
if [ "$USER_EXISTS" = false ]; then
  echo "[IAM] Creating access key for $IAM_USER"
  ACCESS_KEY_OUTPUT=$(awslocal iam create-access-key --user-name "$IAM_USER")
  ACCESS_KEY_ID=$(echo "$ACCESS_KEY_OUTPUT" | grep -o '"AccessKeyId": "[^"]*' | grep -o '[^"]*$')
  SECRET_ACCESS_KEY=$(echo "$ACCESS_KEY_OUTPUT" | grep -o '"SecretAccessKey": "[^"]*' | grep -o '[^"]*$')

  echo "[IAM] Access Key Created:"
  echo "  Access Key ID: $ACCESS_KEY_ID"
  echo "  Secret Access Key: $SECRET_ACCESS_KEY"
  echo ""
  echo "IMPORTANT: Save these credentials now. You won't be able to retrieve the secret key again."
else
  echo "[IAM] User already exists. Skipping access key creation."
  echo "[IAM] If you need new credentials, run ./clean-iam.sh first, then re-run this script."
fi

echo "[IAM] Checking if IAM policy exists: $IAM_POLICY_NAME"
POLICY_ARN=$(awslocal iam list-policies --query "Policies[?PolicyName=='$IAM_POLICY_NAME'].Arn" --output text 2>/dev/null || echo "")

if [[ -n "$POLICY_ARN" ]]; then
  echo "[IAM] Policy already exists: $POLICY_ARN"
else
  echo "[IAM] Creating IAM policy: $IAM_POLICY_NAME"
  POLICY_ARN=$(awslocal iam create-policy \
    --policy-name "$IAM_POLICY_NAME" \
    --policy-document "file://$IAM_POLICY_FILE" \
    --query 'Policy.Arn' \
    --output text)
  echo "[IAM] Policy created: $POLICY_ARN"
fi

echo "[IAM] Checking if policy is already attached to user"
ATTACHED=$(awslocal iam list-attached-user-policies --user-name "$IAM_USER" --query "AttachedPolicies[?PolicyArn=='$POLICY_ARN'].PolicyArn" --output text 2>/dev/null || echo "")

if [[ -n "$ATTACHED" ]]; then
  echo "[IAM] Policy already attached to user."
else
  echo "[IAM] Attaching policy to user"
  awslocal iam attach-user-policy \
    --user-name "$IAM_USER" \
    --policy-arn "$POLICY_ARN"
  echo "[IAM] Policy attached successfully."
fi

echo ""
echo "========================================="
echo "IAM Setup Complete!"
echo "========================================="

if [ "$USER_EXISTS" = false ]; then
  echo ""
  echo "To use this user, configure AWS CLI:"
  echo ""
  echo "  aws configure --profile ci-pipeline"
  echo "  AWS Access Key ID: $ACCESS_KEY_ID"
  echo "  AWS Secret Access Key: $SECRET_ACCESS_KEY"
  echo "  Default region: us-east-1"
  echo "  Default output format: json"
  echo ""
  echo "Then update config.sh to use 'ci-pipeline' profile"
  echo "or set: export AWS_PROFILE=ci-pipeline"
  echo ""
else
  echo ""
  echo "User and policy configuration verified."
  echo "Use your existing ci-pipeline credentials."
  echo ""
fi
