# Lab: AWS Lambda Functions (Python & Java)

## Objective

Learn AWS Lambda serverless computing by creating and deploying functions in both Python and Java. Compare runtimes, understand the Lambda execution model, and practice CloudWatch logging - essential skills for modern serverless architectures.

## What You'll Learn

- ✅ Lambda function creation in Python and Java
- ✅ IAM execution roles for Lambda
- ✅ Function deployment and versioning
- ✅ Lambda invocation via AWS CLI
- ✅ CloudWatch logs for debugging
- ✅ Runtime performance comparison
- ✅ Serverless best practices

## ⚠️ LocalStack Limitation

**Lambda requires LocalStack Pro** for advanced features. Community Edition supports basic Lambda but with limitations:
- ✅ Function creation and invocation work
- ⚠️ Limited CloudWatch logs integration
- ⚠️ Some runtimes may not be fully supported

**Recommended:** Use **AWS Free Tier** for this lab:
- Lambda: 1 million requests/month free (always)
- CloudWatch Logs: 5 GB free
- Cost: $0 for this lab

See `AWS_SETUP.md` for AWS account setup.

## Prerequisites

### For LocalStack (Limited)
- LocalStack running
- AWS CLI configured with localstack profile
- Python 3.11
- Java 17 + Maven

### For Real AWS (Recommended)
- AWS account with credentials configured
- AWS CLI v2
- Python 3.11
- Java 21 + Maven
- `jq` installed (for JSON parsing)
- Helper functions loaded (`source ./config.sh` and `use_aws`)

**WSL/Linux setup:**
```bash
sudo apt install -y openjdk-21-jdk maven jq
```

See `WSL_SETUP.md` for complete WSL configuration.

## Instructions

### 1. Understand the Lambda Functions

Examine both function implementations:

**Python function:**
```bash
cat lambda-python/lambda_function.py
```

**Java function:**
```bash
cat lambda-java/src/main/java/com/example/lambda/Handler.java
```

Notice the different handler patterns and how each runtime structures responses.

### 2. Switch to AWS Mode (Recommended)

```bash
source ./config.sh
use_aws
```

Or to use LocalStack (limited):
```bash
source ./config.sh
use_localstack
```

### 3. Deploy Lambda Functions

Run the setup script to create both functions:

```bash
./setup-lambda.sh
```

This creates:
- IAM execution role (for real AWS)
- Python Lambda function (hello-python)
- Java Lambda function (hello-java)

💡 *The Java build may take 1-2 minutes on first run while Maven downloads dependencies.*

💡 *See "Script Details" section at the end to understand what commands run under the hood.*

### 4. Verify Functions Were Created

List your Lambda functions:

```bash
awscmd lambda list-functions
```

Get details about a specific function:

```bash
awscmd lambda get-function --function-name hello-python
awscmd lambda get-function --function-name hello-java
```

### 5. Invoke the Functions

Test both functions:

```bash
./invoke-lambda.sh
```

This invokes both functions with sample payloads and displays the responses.

**Manual invocation example:**
```bash
awscmd lambda invoke \
    --function-name hello-python \
    --payload '{"name":"Your Name"}' \
    --cli-binary-format raw-in-base64-out \
    response.json

cat response.json | jq '.'
```

### 6. View CloudWatch Logs (Real AWS Only)

If using real AWS, view the execution logs:

```bash
./logs-lambda.sh
```

Or manually:
```bash
awscmd logs tail /aws/lambda/hello-python --since 5m
awscmd logs tail /aws/lambda/hello-java --since 5m
```

### 7. Compare Runtimes

Invoke both functions multiple times and observe:
- **Cold start time** (first invocation)
- **Warm start time** (subsequent invocations)
- **Response format differences**
- **Log output patterns**

Python typically has faster cold starts, but both are fast when warm.

### 8. Experiment (Optional)

Try modifying the functions:
- Add error handling
- Return different status codes
- Add environment variables
- Increase memory/timeout settings

Update a function:
```bash
cd lambda-python
# Edit lambda_function.py
zip ../lambda-python.zip lambda_function.py
cd ..
awscmd lambda update-function-code \
    --function-name hello-python \
    --zip-file fileb://lambda-python.zip
```

### 9. Cleanup

**⚠️ IMPORTANT: Clean up to avoid charges (though minimal for Lambda)**

```bash
./clean-lambda.sh
```

This removes all Lambda functions, IAM roles, and local build artifacts.

💡 *See "Script Details" section to understand the cleanup process.*

## Key Concepts

- **Serverless** - No server management, pay per execution
- **Event-driven** - Functions triggered by events (API calls, S3 uploads, etc.)
- **Execution role** - IAM role that gives Lambda permissions
- **Handler** - The entry point function Lambda calls
- **Cold start** - Initialization delay on first invocation
- **Warm start** - Fast execution when container is already running
- **CloudWatch Logs** - Automatic logging for debugging

## Python vs Java Lambda

| Aspect | Python | Java |
|--------|--------|------|
| **Cold start** | ~100-200ms | ~1-2 seconds |
| **Warm start** | ~1-5ms | ~1-5ms |
| **Package size** | Smaller (~KB) | Larger (~MB with JAR) |
| **Memory usage** | Lower | Higher |
| **Development** | Faster iteration | More boilerplate |
| **Performance** | Good | Excellent (when warm) |
| **Best for** | Quick scripts, APIs | Enterprise, complex logic |

## Interview Talking Points

After completing this lab, you can say:

> "I develop serverless applications using AWS Lambda in both Python and Java. I understand Lambda execution models, cold vs warm starts, and IAM role configuration. I've deployed functions via AWS CLI, integrated with CloudWatch for logging and monitoring, and can compare runtime characteristics to choose the right language for the use case."

## Next Steps

- Add API Gateway to create REST endpoints
- Trigger Lambda from S3 events
- Use Lambda Layers for shared dependencies
- Implement Lambda with DynamoDB
- Explore Step Functions for Lambda orchestration
- Try container image deployments

---

## Script Details (Optional)

This section explains what AWS commands each script executes. Use this to understand the Lambda workflow or run commands manually for learning.

### setup-lambda.sh

Creates IAM role and deploys both Lambda functions:

```bash
# Create IAM execution role (real AWS only)
awscmd iam create-role \
    --role-name lambda-execution-role \
    --assume-role-policy-document '{
      "Version": "2012-10-17",
      "Statement": [{
        "Effect": "Allow",
        "Principal": {"Service": "lambda.amazonaws.com"},
        "Action": "sts:AssumeRole"
      }]
    }'

# Attach Lambda execution policy
awscmd iam attach-role-policy \
    --role-name lambda-execution-role \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Package Python function
cd lambda-python
zip lambda-python.zip lambda_function.py

# Create Python Lambda
awscmd lambda create-function \
    --function-name hello-python \
    --runtime python3.11 \
    --role <ROLE_ARN> \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://lambda-python.zip

# Build Java function
cd lambda-java
mvn clean package

# Create Java Lambda
awscmd lambda create-function \
    --function-name hello-java \
    --runtime java17 \
    --role <ROLE_ARN> \
    --handler com.example.lambda.Handler::handleRequest \
    --zip-file fileb://lambda-java/target/lambda-java-1.0.0.jar \
    --timeout 30 \
    --memory-size 512
```

### invoke-lambda.sh

Invokes both functions and saves responses:

```bash
# Invoke Python Lambda
awscmd lambda invoke \
    --function-name hello-python \
    --payload '{"name":"DevOps Engineer"}' \
    --cli-binary-format raw-in-base64-out \
    response-python.json

# Invoke Java Lambda
awscmd lambda invoke \
    --function-name hello-java \
    --payload '{"name":"Cloud Architect"}' \
    --cli-binary-format raw-in-base64-out \
    response-java.json
```

### logs-lambda.sh

Views CloudWatch logs for both functions (real AWS only):

```bash
# Tail Python Lambda logs
awscmd logs tail /aws/lambda/hello-python --since 5m --format short

# Tail Java Lambda logs
awscmd logs tail /aws/lambda/hello-java --since 5m --format short
```

### clean-lambda.sh

Removes all Lambda resources:

```bash
# Delete Lambda functions
awscmd lambda delete-function --function-name hello-python
awscmd lambda delete-function --function-name hello-java

# Detach policy from role
awscmd iam detach-role-policy \
    --role-name lambda-execution-role \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Delete IAM role
awscmd iam delete-role --role-name lambda-execution-role

# Clean local files
rm -f lambda-python.zip response-*.json
rm -rf lambda-java/target
```

### awscmd helper

All scripts use `awscmd` to work with both LocalStack and real AWS:

- **LocalStack mode**: `awscmd` → `aws --endpoint-url=http://localhost:4566`
- **Real AWS mode**: `awscmd` → `aws --profile default`

Switch between modes:
```bash
source ./config.sh
use_aws         # Switch to real AWS
use_localstack  # Switch to LocalStack
```

---

## License

Licensed under the MIT License.

**Attribution requested:**
If you use this project in a public product or educational material,
please cite: "Developed by W. Simpson / SimpsonConcepts".


## License

Licensed under the MIT License.

**Attribution requested:**
If you use this project in a public product or educational material,
please cite: "Developed by W. Simpson / SimpsonConcepts".
