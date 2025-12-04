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

## 💰 Cost & LocalStack Support

**LocalStack Community (Free):**
- ✅ Pipeline lab works perfectly
- ⚠️ IAM/ECR labs don't support policy enforcement or ECR

**AWS Free Tier (Recommended for IAM/ECR):**
- IAM: Always free
- ECR: 500 MB storage free for 12 months
- Cost: $0 if you run cleanup scripts

See `AWS_SETUP.md` in ECR/IAM branches for AWS account setup.

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

