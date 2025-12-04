# AWS LocalStack Lab

A hands-on learning repository demonstrating real-world AWS DevOps concepts using LocalStack - a local AWS cloud emulator. Each branch is a standalone lab focusing on one core AWS skill.

## Lab Structure

This repository uses a **branch-per-lab** model. Each lab is self-contained and teaches one AWS concept:

- **`testing/pipeline`** - CI/CD Pipeline with S3 deployment
- **`testing/iam`** - IAM least-privilege and role-based access
- More labs coming soon...

> **📝 Note on IAM Lab:** In our testing, IAM policy enforcement was available in LocalStack Pro or real AWS accounts. The Community Edition demonstrated IAM concepts and workflows but did not enforce access restrictions in our testing. See the lab instructions for details.

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

```bash
aws configure --profile localstack
# AWS Access Key ID: test
# AWS Secret Access Key: test
# Default region: us-east-1
# Default output format: json
```

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

Designed for local practice with LocalStack or real AWS (see cost disclaimer in AWS_SETUP.md).

> **Cost Disclaimer:** While some cloud services or cloud service emulation platforms may incur only minimal usage-based charges under certain conditions, actual costs vary by region, usage patterns, account configuration, and local currency exchange rates. Users are solely responsible for evaluating and accepting any financial risk.

## License

Licensed under the MIT License.

**Attribution requested:**
If you use this project in a public product or educational material,
please cite: "Developed by W. Simpson / SimpsonConcepts".

