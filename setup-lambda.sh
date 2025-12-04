#!/usr/bin/env bash
# Setup Lambda functions (Python and Java)
set -euo pipefail

# Load configuration
source ./config.sh

echo "[LAMBDA] Setting up Lambda functions..."

# Create IAM role for Lambda execution (if using real AWS)
if [ "$USE_REAL_AWS" = "true" ]; then
    echo "[LAMBDA] Creating Lambda execution role..."
    
    ROLE_NAME="lambda-execution-role"
    TRUST_POLICY='{
      "Version": "2012-10-17",
      "Statement": [{
        "Effect": "Allow",
        "Principal": {"Service": "lambda.amazonaws.com"},
        "Action": "sts:AssumeRole"
      }]
    }'
    
    # Check if role exists
    if awscmd iam get-role --role-name "$ROLE_NAME" >/dev/null 2>&1; then
        echo "[LAMBDA] Role $ROLE_NAME already exists."
    else
        awscmd iam create-role \
            --role-name "$ROLE_NAME" \
            --assume-role-policy-document "$TRUST_POLICY"
        echo "[LAMBDA] Role created."
        
        # Attach basic Lambda execution policy
        awscmd iam attach-role-policy \
            --role-name "$ROLE_NAME" \
            --policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
        echo "[LAMBDA] Attached Lambda execution policy."
        
        # Wait for role to propagate
        sleep 10
    fi
    
    ROLE_ARN=$(awscmd iam get-role --role-name "$ROLE_NAME" --query 'Role.Arn' --output text)
else
    # LocalStack uses fake ARN
    ROLE_ARN="arn:aws:iam::000000000000:role/lambda-execution-role"
fi

echo "[LAMBDA] Using role: $ROLE_ARN"

# Package and deploy Python Lambda
echo ""
echo "[LAMBDA] Packaging Python Lambda..."
cd lambda-python
zip -q ../lambda-python.zip lambda_function.py
cd ..

echo "[LAMBDA] Creating/updating Python Lambda function..."
if awscmd lambda get-function --function-name hello-python >/dev/null 2>&1; then
    awscmd lambda update-function-code \
        --function-name hello-python \
        --zip-file fileb://lambda-python.zip
    echo "[LAMBDA] Python function updated."
else
    awscmd lambda create-function \
        --function-name hello-python \
        --runtime python3.11 \
        --role "$ROLE_ARN" \
        --handler lambda_function.lambda_handler \
        --zip-file fileb://lambda-python.zip
    echo "[LAMBDA] Python function created."
fi

# Build and deploy Java Lambda
echo ""
echo "[LAMBDA] Building Java Lambda (this may take a minute)..."
cd lambda-java
mvn clean package -q
cd ..

echo "[LAMBDA] Creating/updating Java Lambda function..."
if awscmd lambda get-function --function-name hello-java >/dev/null 2>&1; then
    awscmd lambda update-function-code \
        --function-name hello-java \
        --zip-file fileb://lambda-java/target/lambda-java-1.0.0.jar
    echo "[LAMBDA] Java function updated."
else
    awscmd lambda create-function \
        --function-name hello-java \
        --runtime java17 \
        --role "$ROLE_ARN" \
        --handler com.example.lambda.Handler::handleRequest \
        --zip-file fileb://lambda-java/target/lambda-java-1.0.0.jar \
        --timeout 30 \
        --memory-size 512
    echo "[LAMBDA] Java function created."
fi

echo ""
echo "========================================="
echo "Lambda Setup Complete!"
echo "========================================="
echo ""
echo "Functions created:"
echo "  - hello-python (Python 3.11)"
echo "  - hello-java (Java 17)"
echo ""
echo "Next steps:"
echo "  1. Invoke functions: ./invoke-lambda.sh"
echo "  2. View logs: ./logs-lambda.sh"
echo ""
