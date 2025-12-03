#!/usr/bin/env bash
# Clean up IAM resources
set -euo pipefail

# Load configuration
source ./config.sh

echo "[CLEAN-IAM] Cleaning up IAM resources..."

# List and delete access keys
echo "[CLEAN-IAM] Deleting access keys for $IAM_USER"
ACCESS_KEYS=$(awslocal iam list-access-keys --user-name "$IAM_USER" --query 'AccessKeyMetadata[].AccessKeyId' --output text 2>/dev/null || echo "")
if [[ -n "$ACCESS_KEYS" ]]; then
  for KEY in $ACCESS_KEYS; do
    awslocal iam delete-access-key --user-name "$IAM_USER" --access-key-id "$KEY"
    echo "[CLEAN-IAM] Deleted access key: $KEY"
  done
fi

# Detach policies
echo "[CLEAN-IAM] Detaching policies from $IAM_USER"
ATTACHED_POLICIES=$(awslocal iam list-attached-user-policies --user-name "$IAM_USER" --query 'AttachedPolicies[].PolicyArn' --output text 2>/dev/null || echo "")
if [[ -n "$ATTACHED_POLICIES" ]]; then
  for POLICY_ARN in $ATTACHED_POLICIES; do
    awslocal iam detach-user-policy --user-name "$IAM_USER" --policy-arn "$POLICY_ARN"
    echo "[CLEAN-IAM] Detached policy: $POLICY_ARN"
  done
fi

# Delete user
echo "[CLEAN-IAM] Deleting IAM user: $IAM_USER"
if awslocal iam get-user --user-name "$IAM_USER" >/dev/null 2>&1; then
  awslocal iam delete-user --user-name "$IAM_USER"
  echo "[CLEAN-IAM] User deleted."
else
  echo "[CLEAN-IAM] User does not exist."
fi

# Delete policy
echo "[CLEAN-IAM] Deleting policy: $IAM_POLICY_NAME"
POLICY_ARN=$(awslocal iam list-policies --query "Policies[?PolicyName=='$IAM_POLICY_NAME'].Arn" --output text 2>/dev/null || echo "")
if [[ -n "$POLICY_ARN" ]]; then
  awslocal iam delete-policy --policy-arn "$POLICY_ARN"
  echo "[CLEAN-IAM] Policy deleted: $POLICY_ARN"
else
  echo "[CLEAN-IAM] Policy does not exist."
fi

echo "[CLEAN-IAM] IAM cleanup complete."
