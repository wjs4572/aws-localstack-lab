# Lab: CI/CD Pipeline with LocalStack

## Objective

Build a complete CI/CD pipeline that packages, tests, and deploys a web application to AWS S3 using LocalStack.

## What You'll Learn

✅ Build automation with bash scripts
✅ S3 deployment workflows  
✅ AWS CLI usage
✅ CI/CD pipeline orchestration
✅ Artifact versioning

## Prerequisites

Complete the setup from the main README:
- LocalStack running
- AWS CLI configured with localstack profile
- Helper functions loaded (`source ./setup.sh` or `. .\setup.ps1`)

## Instructions

### 1. Examine the Configuration

All shared settings are centralized in `config.sh`:

```bash
cat config.sh   # View project configuration
```

This file defines:
- Build directories and artifact names
- AWS/LocalStack endpoints and profiles
- Project naming conventions

**Pro tip:** When adapting this for your own projects, just update `config.sh` instead of editing each script individually!

### 2. Examine the Pipeline Structure

```bash
./build.sh      # Packages app into zip
./test.sh       # Validates the artifact
./deploy.sh     # Uploads to S3
./pipeline.sh   # Orchestrates all steps
```

All scripts source `config.sh` to use shared configuration.

### 3. Run the Full Pipeline

```bash
./pipeline.sh dev
```

This will:
1. Build: Package `app/` into `build/app.zip`
2. Test: Validate the artifact exists and contains expected files
3. Deploy: Upload to `s3://ci-lab-dev-bucket` with timestamp versioning

### 3. Verify Deployment

```bash
awslocal s3 ls s3://ci-lab-dev-bucket/
awslocal sts get-caller-identity
```

### 4. Cleanup

**Clean local artifacts:**
```bash
./clean-build.sh
```

**Clean AWS resources:**
```bash
./clean-deploy.sh dev
```

## Key Concepts

- **Centralized configuration** via `config.sh` makes the pipeline easy to adapt for new projects
- **Build artifacts** are versioned with timestamps
- **S3 buckets** are created automatically if they don't exist
- **LocalStack** provides safe, local AWS environment
- **Pipeline orchestration** ensures steps run in correct order

## Next Steps

After completing this lab, try:

- `testing/iam` - Add IAM security and least-privilege access
- Modify the pipeline to deploy to different environments (staging, prod)
- Add additional validation in test.sh

## License

Licensed under the MIT License.

**Attribution requested:**
If you use this project in a public product or educational material,
please cite: "Developed by W. Simpson / SimpsonConcepts".
