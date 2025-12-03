# AWS Account Setup Guide

This guide helps you set up a free AWS account and configure credentials for running labs that require real AWS services (like ECR and IAM policy enforcement).

## Why You Need This

LocalStack Community Edition doesn't support:
- **ECR** (Elastic Container Registry) - Requires LocalStack Pro
- **IAM Policy Enforcement** - Requires LocalStack Pro

You can use a **free-tier AWS account** instead at **zero cost** for these labs.

## Step 1: Create a Free AWS Account

1. Go to **https://aws.amazon.com/free/**
2. Click **"Create a Free Account"**
3. Follow the signup process:
   - Enter email address and choose account name
   - Provide contact information
   - **Credit card required** (won't charge for free tier usage)
   - Verify identity via phone call or SMS
4. Choose the **Free** support plan
5. Complete setup and wait for account activation (usually a few minutes)

## Step 2: Sign In to AWS Console

1. Go to **https://console.aws.amazon.com/**
2. Sign in with your root account credentials
3. You'll see the AWS Management Console dashboard

## Step 3: Create IAM User for CLI Access

**⚠️ Never use root account credentials for CLI!** Create an IAM user instead:

### 3.1 Navigate to IAM

1. In the AWS Console, search for **"IAM"** in the top search bar
2. Click **IAM** (Identity and Access Management)

### 3.2 Create IAM User

1. Click **Users** in the left sidebar
2. Click **Create user**
3. Enter username: `ecr-lab-user` (or any name you prefer)
4. Click **Next**

### 3.3 Set Permissions

1. Select **Attach policies directly**
2. Search for and select these policies:
   - **AmazonEC2ContainerRegistryFullAccess** (for ECR lab)
   - **IAMFullAccess** (for IAM lab)
3. Click **Next** → **Create user**

### 3.4 Create Access Keys

1. Click on the user you just created
2. Go to **Security credentials** tab
3. Scroll down to **Access keys**
4. Click **Create access key**
5. Choose **"Command Line Interface (CLI)"**
6. Check the confirmation box
7. Click **Next** → Optional: Add description tag
8. Click **Create access key**
9. **⚠️ IMPORTANT:** Download the `.csv` file or copy both keys:
   - **Access Key ID** (starts with `AKIA...`)
   - **Secret Access Key** (only shown once!)

## Step 4: Configure AWS CLI

### Option A: In WSL (Linux)

```bash
# Run AWS configure command
aws configure

# Enter your credentials when prompted:
# AWS Access Key ID: <paste your access key ID>
# AWS Secret Access Key: <paste your secret access key>
# Default region name: us-east-1
# Default output format: json
```

### Option B: In PowerShell (Windows)

```powershell
# Run AWS configure command
aws configure

# Enter your credentials when prompted:
# AWS Access Key ID: <paste your access key ID>
# AWS Secret Access Key: <paste your secret access key>
# Default region name: us-east-1
# Default output format: json
```

### Option C: Copy Existing Windows Credentials to WSL

If you already configured AWS CLI in Windows:

```bash
# Create AWS config directory in WSL
mkdir -p ~/.aws

# Copy credentials from Windows to WSL
# Replace YOUR_WINDOWS_USERNAME with your actual Windows username
cp /mnt/c/Users/YOUR_WINDOWS_USERNAME/.aws/credentials ~/.aws/
cp /mnt/c/Users/YOUR_WINDOWS_USERNAME/.aws/config ~/.aws/
```

## Step 5: Verify Credentials

Test that your credentials work:

```bash
# This should return your AWS account info
aws sts get-caller-identity
```

Expected output:
```json
{
    "UserId": "AIDAXXXXXXXXXXXXXXXXX",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/ecr-lab-user"
}
```

## Step 6: Use Real AWS in Labs

### In Bash/WSL:

```bash
# Navigate to the lab
cd ~/repos/ci-localstack-lab

# Load config and switch to real AWS
source ./config.sh
use_aws

# Verify you're using real AWS (should show your account number)
awscmd sts get-caller-identity

# Run the lab
./setup-ecr.sh
```

### In PowerShell:

```powershell
# Navigate to the lab
cd D:\co\github_personal\project_aws_localstack_lab

# Load config and switch to real AWS
. .\config.ps1
use_aws

# Verify you're using real AWS
awscmd sts get-caller-identity

# Run the lab
.\setup-ecr.ps1
```

## Step 7: Clean Up After Labs

**⚠️ CRITICAL:** Always clean up AWS resources to stay within free tier!

```bash
# After completing the ECR lab
./clean-ecr.sh

# After completing the IAM lab
./clean-iam.sh
```

## Free Tier Limits

These labs stay within AWS free tier limits:

### ECR (Container Registry)
- **Storage:** 500 MB free for 12 months
- **Data Transfer:** 500 GB free for 12 months
- **This lab uses:** ~50 MB (well under limit)
- **Cost if you forget cleanup:** ~$0.005/month (half a penny)

### IAM (Identity and Access Management)
- **Always free** - no charges for IAM users, policies, roles

## Security Best Practices

1. **Never commit credentials to git** - They're in `.gitignore` by default
2. **Use IAM user, not root account** - Root account has unlimited access
3. **Delete access keys when done** - Go to IAM → Users → Security credentials → Delete
4. **Set up billing alerts:**
   - AWS Console → Billing → Budgets → Create budget
   - Set alert for $1 to get notified of any charges
5. **Review resources regularly:**
   - AWS Console → Resource Groups → Tag Editor
   - Check for forgotten resources

## Troubleshooting

### "The config profile (default) could not be found"

Run `aws configure` to set up credentials.

### "Unable to locate credentials"

Your credentials aren't configured. Follow Step 4 above.

### "An error occurred (AccessDenied)"

Your IAM user doesn't have the required permissions. Add the necessary policy in IAM console.

### "An error occurred (InvalidClientTokenId)"

Your access key is invalid or deleted. Create a new access key.

### WSL can't find aws command

Install AWS CLI in WSL:
```bash
sudo apt update
sudo apt install awscli -y
```

## Additional Resources

- [AWS Free Tier](https://aws.amazon.com/free/)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [ECR Pricing](https://aws.amazon.com/ecr/pricing/)
