# Export All Branches to ZIP
# Creates a single zip file with each branch in its own directory

$tempDir = "temp-export"
$exportDir = Join-Path $tempDir "aws-localstack-lab"
$zipFile = "aws-localstack-lab-all-branches.zip"

Write-Host "=================================="
Write-Host "  Exporting All Branches"
Write-Host "=================================="
Write-Host ""

# Clean up any existing temp directory
if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
}
New-Item -ItemType Directory -Path $exportDir | Out-Null

# Get all remote branches
Write-Host "Fetching branch list..."
$branches = git branch -r | Where-Object { $_ -notmatch "HEAD" } | ForEach-Object { 
    $_.Trim().Replace("origin/", "") 
}

Write-Host "Found branches: $($branches -join ', ')"
Write-Host ""

# Save current branch
$currentBranch = git rev-parse --abbrev-ref HEAD

# Export each branch
foreach ($branch in $branches) {
    Write-Host "Exporting branch: $branch"
    
    # Create directory name (replace / with -)
    $dirName = $branch -replace "/", "-"
    $branchDir = Join-Path $exportDir $dirName
    
    # Create the directory
    New-Item -ItemType Directory -Path $branchDir | Out-Null
    
    # Checkout the branch and copy files
    git checkout "origin/$branch" -q 2>$null
    
    # Copy all files except .git
    Get-ChildItem -Path . -Force | Where-Object { $_.Name -ne '.git' -and $_.Name -ne 'temp-export' } | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $branchDir -Recurse -Force
    }
    
    Write-Host "  ✅ Exported to $dirName/"
}

# Return to original branch
git checkout $currentBranch -q 2>$null

# Create the zip file
Write-Host ""
Write-Host "Creating zip file..."
if (Test-Path $zipFile) {
    Remove-Item -Force $zipFile
}

Compress-Archive -Path $exportDir -DestinationPath $zipFile

if ($LASTEXITCODE -eq 0 -or (Test-Path $zipFile)) {
    Write-Host "✅ Created: $zipFile"
    
    # Clean up temp directory
    Remove-Item -Recurse -Force $tempDir
    
    Write-Host ""
    Write-Host "=================================="
    Write-Host "  Export Complete!"
    Write-Host "=================================="
    Write-Host ""
    Write-Host "Zip file: $zipFile"
    Write-Host "Size: $([math]::Round((Get-Item $zipFile).Length / 1MB, 2)) MB"
} else {
    Write-Host "❌ Failed to create zip file"
}
