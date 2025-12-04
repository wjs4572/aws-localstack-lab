# WSL Setup Guide for AWS Labs

This guide helps you set up Windows Subsystem for Linux (WSL) with all the tools needed to run the AWS labs in this repository.

## Why WSL?

The lab scripts are written in Bash (`.sh` files) which run natively in Linux/WSL. While you can use Git Bash on Windows, WSL provides:

- ✅ Full Linux environment
- ✅ Better compatibility with AWS CLI
- ✅ Native bash scripting support
- ✅ Easy Java/Maven setup

## Step 1: Install WSL

If you don't have WSL already:

**Option A: PowerShell (Windows 10 version 2004+/Windows 11)**
```powershell
wsl --install
```

**Option B: Manual Install**
1. Enable WSL feature:
   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```
2. Restart your computer
3. Install Ubuntu from Microsoft Store

**Verify installation:**
```powershell
wsl --list --verbose
```

You should see Ubuntu (or your chosen distro) listed.

## Step 2: Update WSL and Install Basic Tools

Open WSL (type `wsl` in PowerShell or click Ubuntu in Start menu):

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl unzip git dos2unix jq
```

**What these tools do:**
- `curl` - Download files from URLs
- `unzip` - Extract zip files
- `git` - Version control (you'll clone the repo here)
- `dos2unix` - Fix Windows line endings in scripts
- `jq` - Parse JSON responses from AWS CLI

## Step 3: Install Java and Maven

The Lambda lab requires Java and Maven to build the Java Lambda function.

**Install Java 21 (latest LTS) and Maven:**
```bash
sudo apt install -y openjdk-21-jdk maven
```

**Verify installation:**
```bash
java -version
# Should show: openjdk version "21.x.x"

mvn -version
# Should show: Apache Maven 3.x.x
```

**Set JAVA_HOME permanently:**
```bash
echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Verify JAVA_HOME:**
```bash
echo $JAVA_HOME
# Should show: /usr/lib/jvm/java-21-openjdk-amd64
```

### Alternative: Use Windows Java (Not Recommended)

If you already have Java on Windows and want to avoid the ~300MB WSL installation, you can point to it:

```bash
# Find your Windows Java installation path (e.g., D:\java\openlogic-openjdk-21.0.8+9-windows-x64)
export JAVA_HOME="/mnt/d/java/YOUR_JAVA_PATH_HERE"
export PATH="$JAVA_HOME/bin:$PATH"
```

**Problem:** Maven and bash scripts expect `java` but Windows uses `java.exe`, causing compatibility issues. **Installing Java natively in WSL is cleaner.**

## Step 4: Install AWS CLI v2

**Download and install:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/
```

**Verify installation:**
```bash
aws --version
# Should show: aws-cli/2.x.x
```

**Configure AWS credentials:**
```bash
aws configure
```

Enter your credentials from the AWS_SETUP.md guide:
- Access Key ID
- Secret Access Key
- Default region: `us-east-1`
- Output format: `json`

**Test it works:**
```bash
aws sts get-caller-identity
```

## Step 5: Clone the Repository

Create a repos directory and clone:

```bash
mkdir -p ~/repos
cd ~/repos
git clone https://github.com/wjs4572/aws-localstack-lab.git
cd aws-localstack-lab
```

**Set up Git config (if first time):**
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Step 6: Fix Line Endings (Important!)

Since the repo might be cloned on Windows first, shell scripts may have Windows line endings (CRLF) which cause errors in Linux. Fix them:

```bash
find . -name "*.sh" -exec dos2unix {} \;
```

This converts all `.sh` files to Linux line endings (LF).

**Note:** The repo has `.gitattributes` to prevent this issue, but if you encounter `\r` errors, run dos2unix.

## Step 7: Test a Lab Script

Let's verify everything works by checking out a lab branch:

```bash
git checkout testing/lambda
source ./config.sh
use_aws
```

You should see:
```
✅ Switched to REAL AWS
[CONFIG] Using REAL AWS (Account: YOUR_ACCOUNT_ID)
```

**Verify Java/Maven for Lambda lab:**
```bash
./setup-lambda.sh --help || echo "Script is executable and Java/Maven are working"
```

## Common Issues and Solutions

### Issue: "java: command not found"

**Solution:**
```bash
sudo apt install -y openjdk-21-jdk
echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc
```

### Issue: "mvn: command not found"

**Solution:**
```bash
sudo apt install -y maven
```

### Issue: "bash: ./setup-lambda.sh: /bin/bash^M: bad interpreter"

This is a line ending issue (Windows CRLF).

**Solution:**
```bash
dos2unix setup-lambda.sh
# Or fix all scripts:
find . -name "*.sh" -exec dos2unix {} \;
```

### Issue: "Permission denied" when running scripts

**Solution:**
```bash
chmod +x *.sh
```

### Issue: AWS CLI returns "Unable to locate credentials"

**Solution:**
```bash
aws configure
# Re-enter your credentials
```

## WSL Pro Tips

### Access Windows files from WSL:
```bash
cd /mnt/c/Users/YourUsername/Documents
cd /mnt/d/Projects
```

### Access WSL files from Windows:
In File Explorer, type: `\\wsl$\Ubuntu\home\yourusername`

### Copy between Windows and WSL:
```bash
# Copy from Windows to WSL
cp /mnt/c/Users/YourUsername/file.txt ~/

# Copy from WSL to Windows
cp ~/file.txt /mnt/c/Users/YourUsername/
```

### Check WSL disk usage:
```bash
df -h
```

### Restart WSL (if needed):
```powershell
# In PowerShell:
wsl --shutdown
wsl
```

## What You've Installed

**Disk space used:** ~500MB-700MB total
- Java 21: ~300MB
- Maven: ~50MB
- AWS CLI: ~100MB
- Other tools: ~50MB

This is minimal compared to the value of having a proper Linux development environment!

## Next Steps

1. ✅ Follow `AWS_SETUP.md` to configure your AWS account
2. ✅ Choose a lab branch (testing/iam, testing/ecr, testing/lambda)
3. ✅ Follow the `LAB_INSTRUCTIONS.md` in that branch
4. ✅ Run the labs using `./setup-*.sh` scripts

## Summary

You now have a complete WSL environment with:
- ✅ Ubuntu Linux
- ✅ Java 21 + Maven
- ✅ AWS CLI v2 configured
- ✅ Git and development tools
- ✅ Repository cloned and ready

Happy learning! 🚀
