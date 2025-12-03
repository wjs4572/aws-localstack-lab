# PowerShell setup script for AWS LocalStack Lab
# Source the awslocal utilities from aws-utils repository

$awsUtilsPath = "D:\co\github_personal\project_aws-utils\aws-utils\scripts\awslocal.ps1"

if (Test-Path $awsUtilsPath) {
    . $awsUtilsPath
    Write-Host "✓ AWS LocalStack utilities loaded (PowerShell)" -ForegroundColor Green
} else {
    Write-Host "✗ Could not find awslocal.ps1 at: $awsUtilsPath" -ForegroundColor Red
    Write-Host "Defining awslocal function locally..." -ForegroundColor Yellow
    
    function awslocal {
        try {
            aws --endpoint-url=http://localhost:4566 --profile localstack $args
        } catch {
            Write-Host "LocalStack does not appear to be running on http://localhost:4566" -ForegroundColor Red
        }
    }
    Write-Host "✓ awslocal function defined locally" -ForegroundColor Green
}
