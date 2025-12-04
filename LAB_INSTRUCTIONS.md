# Lab: Container Registry with ECR

## ⚠️ LocalStack Limitation - Read First!

**ECR requires LocalStack Pro** - it is **not available** in the Community Edition.

When you run the scripts, you'll get this error:
```
An error occurred (InternalFailure) when calling the CreateRepository operation: 
The API for service 'ecr' is either not included in your current license plan 
or has not yet been emulated by LocalStack.
```

### How to Use This Lab

**Option 1: Real AWS (Free Tier - Recommended)**

✅ **Cost: $0** if you clean up (see cleanup section)

**Setup:** See **[AWS_SETUP.md](AWS_SETUP.md)** for complete AWS account setup instructions.

1. Configure AWS credentials (follow AWS_SETUP.md guide)
2. Load the config and switch to real AWS:
   ```bash
   source ./config.sh
   use_aws              # Switches to real AWS
   ```
   Or edit `config.sh` line 14: `export USE_REAL_AWS=true`
3. Run the lab scripts normally - they'll automatically use real AWS
4. **IMPORTANT:** Run `./clean-ecr.sh` when done to avoid charges

💡 **Tip:** Switch back anytime with `use_localstack`

**Option 2: LocalStack Pro**
- Requires paid LocalStack Pro subscription
- Keep `USE_REAL_AWS=false` in `config.sh`
- LocalStack Community Edition **does not support ECR**

**Option 3: Docker-Only Learning (Free)**
- Skip ECR commands, focus on Dockerfile and Docker workflow
- Build and run containers locally without pushing to a registry

**Option 4: Study Mode (Free)**
- Use `AWS_COMMANDS_REFERENCE.tsv` to study ECR command syntax
- Import the TSV into Anki for flashcard study

## Objective

Learn Docker containerization and AWS Elastic Container Registry (ECR) by building, pushing, and deploying containerized applications - essential skills for modern cloud-native deployments.

## What You'll Learn

- ✅ Dockerfile creation for web applications
- ✅ Docker image building and tagging
- ✅ ECR repository management
- ✅ Docker registry authentication with AWS
- ✅ Container image push/pull workflows
- ✅ Running containerized applications
- ✅ Container lifecycle management

## Prerequisites

### For Real AWS (Option 1):
- AWS account with credentials configured (`aws configure`)
- Docker installed and running
- AWS CLI v2 installed

### For LocalStack Pro (Option 2):
- LocalStack Pro subscription and running with docker-compose
- AWS CLI configured with localstack profile
- Docker installed and running

### For All Options:
- Helper functions loaded (`source ./setup.sh` or `. .\setup.ps1`)
- Edit `config.sh` to set `USE_REAL_AWS=true` or `false`

## Instructions

### 1. Understand the Application

Examine the simple web app and Dockerfile:

```bash
cat app/index.html
cat Dockerfile
```

The Dockerfile uses nginx:alpine as the base image and copies the app files to serve them.

### 2. Create ECR Repository

Run the ECR setup script to create a container registry:

```bash
./setup-ecr.sh
```

This creates an ECR repository named `ci-lab-app` where we'll store our Docker images.

**What the script does:**
```bash
awscmd ecr describe-repositories --repository-names ci-lab-app  # Check if exists
awscmd ecr create-repository --repository-name ci-lab-app       # Create repository
```

**Verify the repository:**

```bash
awscmd ecr describe-repositories
```

### 3. Build and Push Docker Image

Build the Docker image and push it to ECR:

```bash
./ecr-push.sh
```

**What the script does:**
```bash
# Build the Docker image from Dockerfile
docker build -t ci-lab-app:latest .

# Tag image for ECR (replace 324728439685 with your AWS account ID)
docker tag ci-lab-app:latest 324728439685.dkr.ecr.us-east-1.amazonaws.com/ci-lab-app:latest

# Authenticate Docker to ECR
awscmd ecr get-login-password | docker login --username AWS --password-stdin 324728439685.dkr.ecr.us-east-1.amazonaws.com

# Push image to ECR
docker push 324728439685.dkr.ecr.us-east-1.amazonaws.com/ci-lab-app:latest
```

**What's happening:**
- `docker build` creates the image layers from Dockerfile instructions
- `docker tag` adds the ECR registry path so Docker knows where to push
- `ecr get-login-password` gets temporary credentials (valid 12 hours)
- `docker push` uploads image layers to ECR

### 4. Verify Image in ECR

List images in the repository:

```bash
awscmd ecr list-images --repository-name ci-lab-app
```

Get detailed image information:

```bash
awscmd ecr describe-images --repository-name ci-lab-app
```

### 5. Pull and Run the Container

Pull the image from ECR and run it:

```bash
./ecr-pull.sh
```

**What the script does:**
```bash
# Authenticate Docker to ECR
awscmd ecr get-login-password | docker login --username AWS --password-stdin 324728439685.dkr.ecr.us-east-1.amazonaws.com

# Pull image from ECR
docker pull 324728439685.dkr.ecr.us-east-1.amazonaws.com/ci-lab-app:latest

# Clean up old container if exists
docker stop ci-lab-app-test
docker rm ci-lab-app-test

# Run container (map port 8080 on host to port 80 in container)
docker run -d --name ci-lab-app-test -p 8080:80 324728439685.dkr.ecr.us-east-1.amazonaws.com/ci-lab-app:latest
```

This demonstrates the pull workflow - authenticating, pulling from the registry, and running the container.

### 6. Test the Running Application

Open your browser to http://localhost:8080 or use curl:

```bash
curl http://localhost:8080
```

You should see the HTML content from `app/index.html`.

**Check container status:**

```bash
docker ps
docker logs ci-lab-app-test
```

### 7. Explore Docker Commands

Try these Docker commands to understand container management:

```bash
# List running containers
docker ps

# View container logs
docker logs ci-lab-app-test

# Execute command in container
docker exec ci-lab-app-test ls /usr/share/nginx/html

# View container details
docker inspect ci-lab-app-test

# Stop the container
docker stop ci-lab-app-test

# Start it again
docker start ci-lab-app-test
```

### 8. Cleanup

**⚠️ IMPORTANT: Run cleanup to avoid AWS charges!**

Clean up all ECR resources:

```bash
./clean-ecr.sh
```

**What the script does:**

```bash
# Stop and remove running container
docker stop ci-lab-app-test
docker rm ci-lab-app-test

# Delete image from ECR
awscmd ecr batch-delete-image --repository-name ci-lab-app --image-ids imageTag=latest

# Delete ECR repository
awscmd ecr delete-repository --repository-name ci-lab-app --force
```

This removes:
- The running container
- Local Docker images
- ECR repository and all images

**Cost Info (Real AWS):**
- ECR storage: **$0.10/GB per month** (500 MB free for 12 months)
- This lab uses ~50 MB = **~$0.005/month** if you forget to delete
- Data transfer OUT: Free within same region, counts toward 500 GB free tier for internet

**Always clean up after labs to stay within free tier!**

## Key Concepts

- **Dockerfile** - Instructions for building a Docker image
- **Docker Image** - Read-only template with application and dependencies
- **Docker Container** - Running instance of an image
- **Container Registry** - Storage for Docker images (like npm for packages)
- **Image Tags** - Version labels for images (e.g., `latest`, `v1.0`)
- **Registry URI** - Full path to image: `registry/repository:tag`

## Docker vs ECR Commands

| Task | Docker Command | ECR Equivalent |
|------|---------------|----------------|
| Build image | `docker build -t name:tag .` | N/A (build locally) |
| List images | `docker images` | `aws ecr list-images` |
| Remove image | `docker rmi name:tag` | `aws ecr batch-delete-image` |
| Tag image | `docker tag src dest` | N/A (done before push) |
| Login | `docker login registry` | `aws ecr get-login-password \| docker login` |
| Push | `docker push name:tag` | `docker push` (after login) |
| Pull | `docker pull name:tag` | `docker pull` (after login) |

## Interview Talking Points

After completing this lab, you can say:

> "I containerize applications using Docker and manage container images with AWS ECR. I create optimized Dockerfiles, build multi-stage images, and implement secure image push/pull workflows using ECR authentication. I understand container lifecycle management and can deploy containerized applications to various environments."

## Next Steps

- Try multi-stage Dockerfiles for smaller images
- Explore image scanning for vulnerabilities (ECR feature)
- Learn about image lifecycle policies (auto-delete old images)
- Combine with ECS/EKS for container orchestration
- Add Docker Compose for multi-container applications

## Common Issues

**Issue: Docker daemon not running**
```bash
# Windows: Start Docker Desktop
# Linux: sudo systemctl start docker
```

**Issue: Port 8080 already in use**
```bash
# Change port in ecr-pull.sh: -p 8081:80
# Or stop the conflicting container
```

**Issue: LocalStack ECR not responding**
```bash
# Restart LocalStack
docker-compose down
docker-compose up -d
```

## License

Licensed under the MIT License.

**Attribution requested:**
If you use this project in a public product or educational material,
please cite: "Developed by W. Simpson / SimpsonConcepts".
