#!/usr/bin/env bash
# Clean up all AWS resources created by the labs
set -euo pipefail

echo "=================================="
echo "  AWS Labs - Complete Cleanup"
echo "=================================="
echo ""
echo "This will delete ALL resources created by:"
echo "  - Database lab (MySQL containers, data)"
echo "  - Lambda lab (functions, IAM roles)"
echo "  - ECR lab (repositories, images)"
echo "  - IAM lab (users, policies)"
echo "  - S3 artifacts (buckets, objects)"
echo ""
read -p "Are you sure you want to proceed? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "Starting cleanup..."

# Clean Database resources (if script exists)
if [ -f "./clean-database.sh" ]; then
    echo ""
    echo "[1/5] Cleaning Database resources..."
    # Auto-confirm database cleanup by piping 'y' responses
    echo -e "y\ny" | ./clean-database.sh 2>/dev/null || docker-compose down 2>/dev/null || echo "⚠️  Database cleanup had issues (may not exist)"
else
    echo "[1/5] No Database cleanup script found (skipping)"
fi

# Clean Lambda resources (if script exists)
if [ -f "./clean-lambda.sh" ]; then
    echo ""
    echo "[2/5] Cleaning Lambda resources..."
    ./clean-lambda.sh || echo "⚠️  Lambda cleanup had issues (may not exist)"
else
    echo "[2/5] No Lambda cleanup script found (skipping)"
fi

# Clean ECR resources (if script exists)
if [ -f "./clean-ecr.sh" ]; then
    echo ""
    echo "[3/5] Cleaning ECR resources..."
    ./clean-ecr.sh || echo "⚠️  ECR cleanup had issues (may not exist)"
else
    echo "[3/5] No ECR cleanup script found (skipping)"
fi

# Clean IAM resources (if script exists)
if [ -f "./clean-iam.sh" ]; then
    echo ""
    echo "[4/5] Cleaning IAM resources..."
    ./clean-iam.sh || echo "⚠️  IAM cleanup had issues (may not exist)"
else
    echo "[4/5] No IAM cleanup script found (skipping)"
fi

# Clean deployment artifacts (if script exists)
if [ -f "./clean-deploy.sh" ]; then
    echo ""
    echo "[5/5] Cleaning deployment artifacts..."
    ./clean-deploy.sh dev || echo "⚠️  Deployment cleanup had issues (may not exist)"
else
    echo "[5/5] No deployment cleanup script found (skipping)"
fi

echo ""
echo "=================================="
echo "  Cleanup Complete!"
echo "=================================="
echo ""
echo "Verify all resources are deleted:"
echo "  aws lambda list-functions"
echo "  aws ecr describe-repositories"
echo "  aws iam list-users"
echo "  aws s3 ls"
echo ""
