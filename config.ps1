# AWS Configuration for LocalStack and Real AWS
# Source this file: . .\config.ps1

# ==============================================================================
# TOGGLE: Set $env:USE_REAL_AWS="true" to use real AWS, "false" for LocalStack
# ==============================================================================
if (-not $env:USE_REAL_AWS) {
  $env:USE_REAL_AWS = "false"  # Default to LocalStack
}

# AWS Configuration
if (-not $env:AWS_REGION) {
  $env:AWS_REGION = "us-east-1"
}

if ($env:USE_REAL_AWS -eq "true") {
  if (-not $env:AWS_PROFILE) {
    $env:AWS_PROFILE = "default"
  }
  try {
    $env:AWS_ACCOUNT_ID = (aws sts get-caller-identity --query Account --output text 2>$null)
  } catch {
    $env:AWS_ACCOUNT_ID = "UNKNOWN"
  }
  Write-Host "[CONFIG] Using REAL AWS (Profile: $env:AWS_PROFILE, Account: $env:AWS_ACCOUNT_ID, Region: $env:AWS_REGION)" -ForegroundColor Green
} else {
  if (-not $env:AWS_PROFILE) {
    $env:AWS_PROFILE = "localstack"
  }
  if (-not $env:LOCALSTACK_ENDPOINT) {
    $env:LOCALSTACK_ENDPOINT = "http://localhost:4566"
  }
  $env:AWS_ACCOUNT_ID = "000000000000"
  Write-Host "[CONFIG] Using LocalStack (Endpoint: $env:LOCALSTACK_ENDPOINT, Region: $env:AWS_REGION)" -ForegroundColor Green
}

# AWS command wrapper that works with both LocalStack and real AWS
function awscmd {
  if ($env:USE_REAL_AWS -eq "true") {
    aws --profile $env:AWS_PROFILE --region $env:AWS_REGION $args
  } else {
    aws --endpoint-url=$env:LOCALSTACK_ENDPOINT --profile $env:AWS_PROFILE $args
  }
}

# Backward compatibility: awslocal alias
function awslocal {
  awscmd $args
}

# Helper functions to switch between AWS and LocalStack
function use_aws {
  $env:USE_REAL_AWS = "true"
  . $PSCommandPath
  Write-Host "[OK] Switched to REAL AWS" -ForegroundColor Green
}

function use_localstack {
  $env:USE_REAL_AWS = "false"
  . $PSCommandPath
  Write-Host "[OK] Switched to LocalStack" -ForegroundColor Green
}

# Project-specific configuration
$env:PROJECT_NAME = "ci-lab"
$env:BUILD_DIR = "build"
$env:ARTIFACT_NAME = "app.zip"
$env:APP_DIR = "app"

# IAM Configuration
$env:IAM_USER = "ci-pipeline-user"
$env:IAM_POLICY_NAME = "CIPipelinePolicy"
$env:IAM_POLICY_FILE = "policies/ci-pipeline-policy.json"

# ECR Configuration
$env:ECR_REPOSITORY_NAME = "ci-lab-app"
$env:IMAGE_TAG = "latest"

# Set ECR Registry based on environment
if ($env:USE_REAL_AWS -eq "true") {
    if (-not $env:AWS_ACCOUNT_ID) {
        try {
            $env:AWS_ACCOUNT_ID = (aws sts get-caller-identity --query Account --output text 2>$null)
        } catch {
            $env:AWS_ACCOUNT_ID = "UNKNOWN"
        }
    }
    $env:ECR_REGISTRY = "$($env:AWS_ACCOUNT_ID).dkr.ecr.$($env:AWS_REGION).amazonaws.com"
} else {
    $env:AWS_ACCOUNT_ID = "000000000000"
    $env:ECR_REGISTRY = "$($env:AWS_ACCOUNT_ID).dkr.ecr.$($env:AWS_REGION).localhost.localstack.cloud:4566"
}

Write-Host "[OK] Project configuration loaded (PowerShell)" -ForegroundColor Green
Write-Host "  Project: $env:PROJECT_NAME"
Write-Host "  ECR Registry: $($env:ECR_REGISTRY)"
