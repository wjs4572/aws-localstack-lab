# AWS Account Setup Guide

This guide walks you through setting up an AWS account and creating an IAM user with the necessary permissions to run all labs in this repository.

## Why Real AWS Instead of LocalStack?

While this repository supports LocalStack for local testing, **real AWS is recommended** because:

- ✅ **AWS Free Tier** - Many services offer free tiers for learning
- ✅ **Full feature support** - Complete service implementations
- ✅ **Real-world experience** - Actual AWS behavior, not simulations
- ✅ **Portfolio value** - Can demonstrate on real infrastructure

> **Cost Disclaimer:** While some cloud services or cloud service emulation platforms may incur only minimal usage-based charges under certain conditions, actual costs vary by region, usage patterns, account configuration, and local currency exchange rates. Users are solely responsible for evaluating and accepting any financial risk.

## Step 1: Create AWS Account

1. Go to [aws.amazon.com](https://aws.amazon.com)
2. Click **Create an AWS Account**
3. Follow the signup process:
   - Email address
   - Account name (use something like "DevOps-Lab")
   - Credit card (required for account verification)
   - Identity verification (phone)

4. Choose **Basic Support (Free)** plan

**✅ You now have an AWS account!** This is your "root" account - we'll create a restricted IAM user next.

## Step 2: Create IAM User for Labs

**⚠️ IMPORTANT:** Never use your root account for day-to-day tasks. Create an IAM user instead.

### 2.1 Sign in to AWS Console

1. Go to [console.aws.amazon.com](https://console.aws.amazon.com)
2. Sign in with your root account credentials

### 2.2 Navigate to IAM

1. In the search bar at the top, type **IAM**
2. Click **IAM** (Identity and Access Management)

### 2.3 Create User

1. In the left sidebar, click **Users**
2. Click **Create user** button
3. Enter username: `homelab` (or your preferred name)
4. Click **Next**

### 2.4 Attach Policies

On the "Set permissions" page, select **Attach policies directly**, then attach these AWS managed policies:

**Required for all labs:**
- ✅ `IAMFullAccess` - For IAM lab and Lambda execution roles

**For ECR lab:**
- ✅ `AmazonEC2ContainerRegistryFullAccess` - For Docker image push/pull

**For Lambda lab:**
- ✅ `AWSLambda_FullAccess` - For Lambda function deployment
- ✅ `CloudWatchLogsFullAccess` - For viewing Lambda logs

**Optional (for future labs):**
- `AmazonS3FullAccess` - If you add S3-based labs
- `AmazonECS_FullAccess` - If you add ECS labs
- `CloudFormationFullAccess` - For infrastructure as code labs

Click **Next**, then **Create user**.

### 2.5 Create Access Keys

1. Click on the newly created user (`homelab`)
2. Go to the **Security credentials** tab
3. Scroll down to **Access keys**
4. Click **Create access key**
5. Select use case: **Command Line Interface (CLI)**
6. Check the confirmation box
7. Click **Next**, then **Create access key**

**⚠️ CRITICAL:** Copy both values immediately:
- **Access Key ID** (e.g., `AKIAIOSFODNN7EXAMPLE`)
- **Secret Access Key** (e.g., `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`)

**You will never see the Secret Access Key again!** Store it securely.

### 2.6 Get Your Account ID

You'll need your AWS account ID for some operations:

1. Click your username in the top-right corner
2. Your **Account ID** is shown (12 digits, e.g., `324728439685`)
3. Copy and save this

## Step 3: Configure AWS CLI

### 3.1 Install AWS CLI v2

**Windows:**
```powershell
# Download and run the installer from:
# https://awscli.amazonaws.com/AWSCLIV2.msi
```

**Linux/WSL:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

**Mac:**
```bash
brew install awscli
```

Verify installation:
```bash
aws --version
# Should show: aws-cli/2.x.x ...
```

### 3.2 Configure Credentials

Run the configuration wizard:

```bash
aws configure
```

Enter your values:
- **AWS Access Key ID:** [paste from Step 2.5]
- **AWS Secret Access Key:** [paste from Step 2.5]
- **Default region name:** `us-east-1` (or your preferred region)
- **Default output format:** `json`

This creates `~/.aws/credentials` with your access keys.

### 3.3 Verify Configuration

Test that everything works:

```bash
aws sts get-caller-identity
```

Expected output:
```json
{
    "UserId": "AIDAXXXXXXXXXXXXX",
    "Account": "324728439685",
    "Arn": "arn:aws:iam::324728439685:user/homelab"
}
```

✅ **You're all set!** The AWS CLI is now configured.

## Step 4: Test Permissions

Verify you have the necessary permissions for each lab:

### Test IAM Access
```bash
aws iam list-users
# Should list users including 'homelab'
```

### Test ECR Access
```bash
aws ecr describe-repositories
# Should return empty list or your repositories
```

### Test Lambda Access
```bash
aws lambda list-functions
# Should return empty list or your functions
```

### Test CloudWatch Logs Access
```bash
aws logs describe-log-groups
# Should return empty list or your log groups
```

If any command fails with `AccessDenied`, go back to Step 2.4 and ensure the policy is attached.

## Step 5: Set Budget Alerts (Optional but Recommended)

Protect yourself from unexpected charges:

1. Go to [AWS Billing Console](https://console.aws.amazon.com/billing/)
2. Click **Budgets** in the left sidebar
3. Click **Create budget**
4. Choose **Zero spend budget** (gets alert on any charges)
5. Or create a custom budget (set your own threshold)
6. Enter your email for notifications
7. Click **Create budget**

## Cost Management Tips

**To minimize AWS costs:**

1. ✅ **Always run cleanup scripts** after each lab
   - `./clean-lambda.sh`
   - `./clean-ecr.sh`
   - `./clean-iam.sh`

2. ✅ **Verify resources are deleted:**
   ```bash
   aws lambda list-functions
   aws ecr describe-repositories
   aws iam list-roles --query 'Roles[?starts_with(RoleName, `lambda-`)]'
   ```

3. ✅ **Use AWS Free Tier services:**
   - Lambda: 1M requests/month free (always)
   - ECR: 500 MB storage/month free (12 months)
   - CloudWatch Logs: 5 GB free
   - IAM: Always free

4. ✅ **Check billing dashboard monthly:**
   - [AWS Billing Console](https://console.aws.amazon.com/billing/)
   - Look for unexpected charges

5. ✅ **Delete old CloudWatch log groups:**
   ```bash
   aws logs describe-log-groups
   aws logs delete-log-group --log-group-name /aws/lambda/old-function
   ```

## Free Tier Eligibility

**12-month free tier** (from account creation):
- ECR: 500 MB storage/month
- CloudWatch: 5 GB logs, 10 custom metrics

**Always free:**
- Lambda: 1M requests/month + 400,000 GB-seconds compute
- IAM: All features
- CloudWatch Logs: 5 GB ingestion, 5 GB archive, 5 GB scan

**What this means:** These labs are designed to work within typical Free Tier limits when used as intended. Users should monitor their AWS billing dashboard and set up budget alerts.

## Security Best Practices

### ✅ DO:
- Use IAM user (not root) for all lab work
- Enable MFA on root account
- Rotate access keys periodically (every 90 days)
- Delete unused IAM users/roles
- Use least-privilege policies when possible

### ❌ DON'T:
- Share access keys in public repos
- Commit credentials to Git
- Use root account for labs
- Leave resources running indefinitely
- Grant more permissions than needed

## Troubleshooting

### "AccessDenied" Errors

**Problem:** `User: arn:aws:iam::xxx:user/homelab is not authorized to perform: lambda:CreateFunction`

**Solution:**
1. Go to IAM Console → Users → homelab
2. Click **Add permissions** → **Attach policies directly**
3. Find and attach the missing policy (e.g., `AWSLambda_FullAccess`)
4. Wait 30-60 seconds for IAM policy propagation
5. Retry the command

### "InvalidClientTokenId" Error

**Problem:** `The security token included in the request is invalid`

**Solution:**
```bash
aws configure
# Re-enter your Access Key ID and Secret Access Key
```

### "Region Not Supported" Error

**Problem:** Some services aren't available in all regions

**Solution:**
```bash
aws configure set region us-east-1
# Use us-east-1 (Virginia) - most complete service availability
```

### Verify Current Configuration

```bash
aws configure list
aws sts get-caller-identity
```

## Next Steps

1. ✅ Choose a lab branch:
   - `testing/iam` - IAM least-privilege policies
   - `testing/ecr` - Docker image registry
   - `testing/lambda` - Serverless functions (Python + Java)

2. ✅ Follow the `LAB_INSTRUCTIONS.md` in that branch

3. ✅ Run the lab with real AWS:
   ```bash
   source ./config.sh
   use_aws
   # Run lab scripts
   ```

4. ✅ Clean up after completion:
   ```bash
   ./clean-*.sh
   ```

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Verify your IAM policies are attached
3. Check [AWS Service Health Dashboard](https://status.aws.amazon.com/)
4. Review AWS CloudTrail for API errors (advanced)

---

**Remember:** The goal is to learn AWS services hands-on. Real AWS experience is more valuable than LocalStack simulation for your portfolio and career!
