# AWS LocalStack Lab

A hands-on learning repository demonstrating real-world AWS DevOps concepts using LocalStack and real AWS. Each branch is a complete, tested lab focusing on one core AWS skill.

## 🎯 Repository Structure

This repository uses a **branch-per-lab** model where each lab is isolated on its own branch. This approach:
- ✅ Keeps each lab focused and self-contained
- ✅ Demonstrates Git branch workflow (common in DevOps)
- ✅ Allows independent development and testing
- ✅ Makes it easy to work on one skill at a time

## 📚 Available Labs

| Lab | Branch | Status | AWS Cost | LocalStack Support |
|-----|--------|--------|----------|-------------------|
| **CI/CD Pipeline** | `testing/pipeline` | ✅ Complete | Free (S3 only) | ✅ Community |
| **IAM Least-Privilege** | `testing/iam` | ✅ Tested with real AWS | Always free | ⚠️ Pro only |
| **Container Registry (ECR)** | `testing/ecr` | ✅ Tested with real AWS | Free tier (500MB) | ⚠️ Pro only |

### Quick Start

```bash
# Clone the repository
git clone https://github.com/wjs4572/aws-localstack-lab.git
cd aws-localstack-lab

# Choose a lab and checkout its branch
git checkout testing/pipeline   # Start with pipeline (works on LocalStack Community)
git checkout testing/iam        # Or try IAM (use AWS free tier)
git checkout testing/ecr        # Or try ECR (use AWS free tier)

# Each branch has complete LAB_INSTRUCTIONS.md
```

## 🚀 What You'll Learn

This lab series covers essential AWS DevOps skills:

- ✅ **CI/CD Pipelines** - Automated build, test, and deployment workflows
- ✅ **IAM Security** - Least-privilege policies and role-based access control
- ✅ **Container Management** - Docker, ECR, and container workflows
- ✅ **Infrastructure as Code** - Automated resource provisioning
- ✅ **AWS CLI Mastery** - Command-line automation and scripting

Each lab includes:
- 📖 Step-by-step instructions
- 🔧 Working scripts you can run and study
- 💡 Script details appendix showing actual AWS commands
- 📝 Anki flashcards for command reference

## 💰 Cost & Technology Choices

> **Technology Selection Disclaimer:** The technologies used in this project were selected based on project-specific requirements, testing results, and practical development constraints observed at the time of implementation. These selections reflect the scope and goals of this work and should not be interpreted as endorsements or guarantees of performance, cost, or future availability.

**Technologies used in this project include:**

- AWS CLI for command-line interaction with cloud-style APIs
- LocalStack for local cloud service emulation
- Docker for containerized service execution
- Bash for CI/CD pipeline scripting
- GitHub for source control and versioning

**LocalStack Community Edition (based on our testing):**
- ✅ Pipeline lab functionality observed
- ⚠️ IAM/ECR policy enforcement not available in our testing

**AWS Free Tier:**
- IAM: Always free tier available
- ECR: 500 MB storage free tier (12 months)

> **Cost Disclaimer:** While some cloud services or cloud service emulation platforms may incur only minimal usage-based charges under certain conditions, actual costs vary by region, usage patterns, account configuration, and local currency exchange rates. Users are solely responsible for evaluating and accepting any financial risk.

See `AWS_SETUP.md` in lab branches for account setup details.

## Prerequisites

### For Pipeline Lab (LocalStack)

- Docker
- LocalStack running: `docker run -d -p 4566:4566 localstack/localstack`
- AWS CLI v2
- Bash or Git Bash (Windows)

### For IAM/ECR Labs (Real AWS)

- AWS account (free tier)
- AWS CLI configured with credentials
- Docker (for ECR lab)

See individual lab branches for detailed setup instructions.

## 🎓 Learning Path

**Recommended order:**

1. **Pipeline Lab** (`testing/pipeline`) - Start here, works on LocalStack Community
2. **IAM Lab** (`testing/iam`) - Learn security, use AWS free tier
3. **ECR Lab** (`testing/ecr`) - Container workflows, use AWS free tier

## License

Licensed under the MIT License.

**Attribution requested:**
If you use this project in a public product or educational material,
please cite: "Developed by W. Simpson / SimpsonConcepts".

