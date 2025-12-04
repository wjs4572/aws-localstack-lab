# AWS LocalStack Lab

A hands-on learning repository demonstrating real-world AWS DevOps concepts. Learn AWS CLI, Docker, IAM, and CI/CD pipelines with hands-on labs.

> **Technology Selection Disclaimer:** The technologies used in this project were selected based on project-specific requirements, testing results, and practical development constraints observed at the time of implementation. These selections reflect the scope and goals of this work and should not be interpreted as endorsements or guarantees of performance, cost, or future availability.

> **Cost Disclaimer:** While some cloud services or cloud service emulation platforms may incur only minimal usage-based charges under certain conditions, actual costs vary by region, usage patterns, account configuration, and local currency exchange rates. Users are solely responsible for evaluating and accepting any financial risk.

## 🎯 Which Lab Should I Use?

| Lab | Works with LocalStack Community (Free) | Best Way to Run It |
|-----|---------------------------------------|-------------------|
| **Pipeline (S3)** | ✅ Based on testing | LocalStack locally |
| **IAM** | ⚠️ Limited in our testing | AWS Free Tier or CloudShell |
| **ECR** | ⚠️ Limited in our testing | AWS Free Tier + local Docker |

**Summary:** 
- **Pipeline lab** - LocalStack Community functionality observed
- **IAM/ECR labs** - AWS Free Tier recommended based on testing results

## Lab Structure

This repository uses a **branch-per-lab** model. Each lab is self-contained:

- **`testing/pipeline`** - CI/CD Pipeline with S3 deployment 🟢 **LocalStack Community works!**
- **`testing/iam`** - IAM least-privilege and role-based access 🔴 **AWS free tier recommended**
- **`testing/ecr`** - Container Registry with Docker and ECR 🔴 **AWS free tier recommended**
- More labs coming soon...

### LocalStack Observations

Based on our testing at the time of implementation:

- LocalStack Community Edition provided functionality for basic services (S3, SQS, Lambda)
- Advanced features (IAM enforcement, ECR) were available in paid tiers during our testing
- AWS Free Tier was used for IAM and ECR labs to access full service functionality

## 🚀 Quick Decision Guide

**"I just want to learn AWS without spending money"**
→ Start with **Pipeline lab** on LocalStack Community (free), then use **AWS free tier** for IAM/ECR labs

**"I want the easiest setup possible"**
→ Use **AWS CloudShell** (browser-based, no local setup) for IAM lab. Skip ECR or use AWS free tier + local Docker.

**"I have LocalStack Pro for work"**
→ Lucky you! All labs will work locally with LocalStack Pro.

**"I just want to study for AWS certification"**
→ Use the `AWS_COMMANDS_REFERENCE.tsv` flashcards. Import into Anki for spaced repetition.

### Quick Start (Pipeline Lab - LocalStack Community)

```bash
git clone https://github.com/wjs4572/aws-localstack-lab.git
cd aws-localstack-lab
git checkout testing/pipeline   # S3 pipeline lab - works with free LocalStack!
docker run -d -p 4566:4566 localstack/localstack  # Start LocalStack
```

### Quick Start (IAM/ECR Labs - Real AWS)

```bash
# 1. Set up AWS account (free tier) - see AWS_SETUP.md
# 2. Clone and run
git clone https://github.com/wjs4572/aws-localstack-lab.git
cd aws-localstack-lab
git checkout testing/ecr  # or testing/iam
source ./config.sh
use_aws                   # Switch to real AWS
./setup-ecr.sh            # Run the lab
```

## Prerequisites

### For Pipeline Lab (LocalStack Community)

- Docker
- LocalStack (running on `http://localhost:4566`)
- AWS CLI v2
- Bash or Git Bash (Windows)
- PowerShell (Windows users)

### Setup LocalStack

```bash
docker run -d -p 4566:4566 localstack/localstack
```

### Configure AWS CLI

**For LocalStack:**

```bash
aws configure --profile localstack
# AWS Access Key ID: test
# AWS Secret Access Key: test
# Default region: us-east-1
# Default output format: json
```

**For Real AWS (IAM/ECR labs):**

See **[AWS_SETUP.md](AWS_SETUP.md)** for complete instructions on:
- Creating a free AWS account
- Setting up IAM user with proper permissions
- Configuring AWS CLI credentials
- Using real AWS with the labs

> 💡 **Tip:** To use real AWS for labs marked "Pro only":
> ```bash
> source ./config.sh
> use_aws              # Switches to real AWS
> use_localstack       # Switches back to LocalStack
> ```
> Or edit `config.sh` and set `USE_REAL_AWS=true`

### Load Helper Functions

**Bash/WSL:**

```bash
source ./setup.sh
```

**PowerShell:**

```powershell
. .\setup.ps1
```

This loads AWS utilities including:
- `awscmd` - Works with both LocalStack and real AWS
- `awslocal` - Alias for backward compatibility
- `use_aws` - Switch to real AWS in current session
- `use_localstack` - Switch back to LocalStack

## What You'll Learn

This lab series covers essential AWS DevOps skills that employers expect:

- ✅ CI/CD pipelines with AWS services
- ✅ IAM security and least-privilege access
- ✅ Infrastructure as Code
- ✅ Container deployments
- ✅ Real-world DevOps workflows

All safely practiced locally with LocalStack - no AWS charges!

## License

Licensed under the MIT License.

**Attribution requested:**
If you use this project in a public product or educational material,
please cite: "Developed by W. Simpson / SimpsonConcepts".

