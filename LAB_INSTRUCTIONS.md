# Lab: IAM Least-Privilege Deployment

## Objective

Demonstrate IAM security best practices by creating a restricted IAM user with the minimum permissions needed to run the CI/CD pipeline, proving you understand least-privilege access control.

## What You'll Learn

- ✅ IAM user creation and management
- ✅ Least-privilege policy design
- ✅ Access key management
- ✅ Role-based access control for CI/CD
- ✅ Security boundary testing
- ✅ Difference between admin and restricted users

## Prerequisites

Complete the setup from the main README:

- LocalStack running
- AWS CLI configured with localstack profile
- Helper functions loaded (`source ./setup.sh` or `. .\setup.ps1`)

## Instructions

### 1. Understand the Current State (Root User)

First, verify you're using the default LocalStack root user (full admin access):

```bash
awslocal sts get-caller-identity
```

You should see `"Arn": "arn:aws:iam::000000000000:root"` - this has unlimited permissions.

### 2. Run the Pipeline as Root (Baseline)

Run the pipeline with full admin access to see it work:

```bash
./pipeline.sh dev
```

This succeeds because the root user can do anything.

### 3. Examine the IAM Policy

Look at the least-privilege policy:

```bash
cat policies/ci-pipeline-policy.json
```

Notice it ONLY allows:

- S3 bucket creation
- S3 list/get/put operations
- Only on buckets matching `ci-lab-*`

**No EC2, no Lambda, no RDS** - just what the pipeline needs!

### 4. Create the Restricted IAM User

Run the IAM setup script:

```bash
./setup-iam.sh
```

This will:

1. Create IAM user `ci-pipeline-user`
2. Generate access keys (save these!)
3. Create the least-privilege policy
4. Attach the policy to the user

**IMPORTANT:** Copy the Access Key ID and Secret Access Key from the output!

### 5. Configure AWS CLI with the New User

```bash
aws configure --profile ci-pipeline
```

Enter:

- **AWS Access Key ID:** [from setup-iam.sh output]
- **AWS Secret Access Key:** [from setup-iam.sh output]
- **Default region:** us-east-1
- **Default output format:** json

### 6. Test with the Restricted User

Update `config.sh` to use the new profile:

```bash
# Change this line in config.sh:
export AWS_PROFILE="ci-pipeline"  # Was "localstack"
```

Now run the pipeline with restricted permissions:

```bash
./pipeline.sh dev
```

✅ **It should still work!** The policy grants exactly what's needed.

### 7. Verify Security Boundaries

Try to do something outside the policy:

```bash
# This should FAIL with Access Denied
awslocal ec2 describe-instances

# This should also FAIL - wrong bucket prefix
awslocal s3 mb s3://my-other-bucket

# This should WORK - matches ci-lab-* pattern
awslocal s3 mb s3://ci-lab-test-bucket
```

This proves the policy is enforcing least-privilege!

### 8. Cleanup

**Clean up S3 resources:**

```bash
./clean-deploy.sh dev
```

**Clean up IAM resources:**

```bash
./clean-iam.sh
```

**Reset config.sh:**

```bash
# Change back to:
export AWS_PROFILE="localstack"
```

## Key Concepts

- **Least Privilege** - Users get minimum permissions needed, nothing more
- **Resource-based restrictions** - Policy limits actions to specific resources (`ci-lab-*`)
- **Separation of concerns** - Pipeline user vs. admin user
- **Access keys** - Credentials for programmatic access (not passwords)
- **Security boundaries** - IAM enforces what actions are allowed

## Interview Talking Points

After completing this lab, you can say:

> "I implement least-privilege IAM policies for CI/CD pipelines. I create dedicated service accounts with only the S3 permissions needed for artifact deployment, tested in LocalStack. I understand resource-based restrictions and can demonstrate security boundaries by showing what actions are denied outside the policy scope."

## Next Steps

- Try modifying the policy to be even more restrictive (e.g., read-only)
- Add a second policy for a different use case (e.g., CloudWatch logs)
- Explore IAM roles vs. users
- Investigate AWS STS for temporary credentials

## License

Licensed under the MIT License.

**Attribution requested:**
If you use this project in a public product or educational material,
please cite: "Developed by W. Simpson / SimpsonConcepts".
