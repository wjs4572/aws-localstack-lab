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

This creates:
- IAM user `ci-pipeline-user`
- Access keys for programmatic access
- The least-privilege policy from `policies/ci-pipeline-policy.json`
- Policy attachment linking user to policy

**IMPORTANT:** Copy the Access Key ID and Secret Access Key from the output!

💡 *See "Script Details" section at the end to understand what commands run under the hood.*

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

> **⚠️ IMPORTANT - LocalStack Limitation:**
> IAM policy enforcement is a **LocalStack Pro feature only**. The Community Edition (free) will create IAM users and policies but **will not enforce them**. All commands will succeed regardless of the policy.
>
> **To fully test IAM enforcement, you need:**
> - LocalStack Pro (paid subscription), OR
> - Real AWS account (free tier eligible)
>
> **What this lab teaches:** Even though enforcement doesn't work in Community Edition, this lab demonstrates:
> - ✅ How to write least-privilege IAM policies
> - ✅ IAM user and policy management workflows
> - ✅ Access key configuration
> - ✅ AWS CLI profile switching
> - ✅ Production-ready IAM patterns you'll use in real AWS

#### Testing in LocalStack Community Edition

Even without enforcement, verify your configuration is correct:

```bash
# Verify you're using the ci-pipeline profile
awslocal sts get-caller-identity
# Should show: "Arn": "arn:aws:iam::000000000000:user/ci-pipeline-user"

# Verify the policy is attached
awslocal iam list-attached-user-policies --user-name ci-pipeline-user
# Should show: "PolicyName": "CIPipelinePolicy"

# Get the policy document to verify it's correct
awslocal iam get-policy --policy-arn arn:aws:iam::000000000000:policy/CIPipelinePolicy
awslocal iam get-policy-version \
  --policy-arn arn:aws:iam::000000000000:policy/CIPipelinePolicy \
  --version-id v1
# Review the JSON to confirm S3-only permissions on ci-lab-* resources
```

#### Testing in Real AWS or LocalStack Pro

If you have access to real AWS or LocalStack Pro, test enforcement:

```bash
# This should FAIL with AccessDenied - EC2 not in policy
awslocal ec2 describe-instances

# This should FAIL with AccessDenied - wrong bucket prefix
awslocal s3 mb s3://my-other-bucket

# This should SUCCEED - matches ci-lab-* pattern
awslocal s3 mb s3://ci-lab-test-bucket

# This should FAIL - IAM actions not in policy
awslocal iam list-users
```

**Expected results with enforcement:**
- ✅ S3 operations on `ci-lab-*` buckets succeed
- ❌ S3 operations on other buckets fail with `AccessDenied`
- ❌ EC2, IAM, and other service operations fail with `AccessDenied`

This proves the policy is enforcing least-privilege correctly!

### 8. Cleanup

**Clean up S3 resources:**

```bash
./clean-deploy.sh dev
```

**Clean up IAM resources:**

```bash
./clean-iam.sh
```

This removes all IAM resources created in step 4.

💡 *See "Script Details" section below to see what commands are executed.*

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

---

## Script Details (Optional)

This section explains what AWS commands each script executes. Use this to understand the IAM workflow or run commands manually for learning.

### setup-iam.sh

Creates the IAM user, access keys, and policy:

```bash
# Check if user exists
awscmd iam get-user --user-name ci-pipeline-user

# Create IAM user (if doesn't exist)
awscmd iam create-user --user-name ci-pipeline-user

# Create access keys for the user
awscmd iam create-access-key --user-name ci-pipeline-user

# Create the least-privilege policy from JSON file
awscmd iam create-policy \
  --policy-name CIPipelinePolicy \
  --policy-document file://policies/ci-pipeline-policy.json

# Attach the policy to the user
awscmd iam attach-user-policy \
  --user-name ci-pipeline-user \
  --policy-arn arn:aws:iam::000000000000:policy/CIPipelinePolicy
```

### clean-iam.sh

Removes all IAM resources:

```bash
# List and delete all access keys for the user
awscmd iam list-access-keys --user-name ci-pipeline-user
awscmd iam delete-access-key --user-name ci-pipeline-user --access-key-id <KEY_ID>

# Detach policies from user
awscmd iam list-attached-user-policies --user-name ci-pipeline-user
awscmd iam detach-user-policy \
  --user-name ci-pipeline-user \
  --policy-arn arn:aws:iam::000000000000:policy/CIPipelinePolicy

# Delete the IAM user
awscmd iam delete-user --user-name ci-pipeline-user

# Delete the IAM policy
awscmd iam delete-policy --policy-arn arn:aws:iam::000000000000:policy/CIPipelinePolicy
```

### awscmd helper

All scripts use `awscmd` instead of `aws` directly. This function automatically routes commands to either LocalStack or real AWS based on your configuration:

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
