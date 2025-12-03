# AWS LocalStack Lab

A hands-on learning repository demonstrating real-world AWS DevOps concepts using LocalStack - a local AWS cloud emulator. Each branch is a standalone lab focusing on one core AWS skill.

## Lab Structure

This repository uses a **branch-per-lab** model. Each lab is self-contained and teaches one AWS concept:

- **`testing/pipeline`** - CI/CD Pipeline with S3 deployment
- **`testing/iam`** - IAM least-privilege and role-based access ⚠️ *Pro only*
- **`testing/ecr`** - Container Registry with Docker and ECR ⚠️ *Pro only*
- More labs coming soon...

> **📝 LocalStack Limitations:** IAM policy enforcement and ECR require LocalStack Pro (paid). Community Edition users can:
> - Use these labs with a free-tier AWS account instead
> - Study AWS CLI syntax with the provided flashcards (`AWS_COMMANDS_REFERENCE.tsv`)
> - Learn workflows and concepts even if enforcement doesn't work locally

### Quick Start

```bash
git clone https://github.com/wjs4572/aws-localstack-lab.git
cd aws-localstack-lab
git checkout testing/pipeline   # Start with the pipeline lab
```

## Prerequisites (All Labs)

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

```bash
aws configure
# Enter your actual AWS credentials
# Get credentials from AWS Console → IAM → Security credentials
```

> 💡 **Tip:** To use real AWS for labs marked "Pro only", edit `config.sh` and set `USE_REAL_AWS=true`

### Load Helper Functions

**Bash/WSL:**

```bash
source ./setup.sh
```

**PowerShell:**

```powershell
. .\setup.ps1
```

This loads the `awslocal` function that simplifies LocalStack commands.

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

