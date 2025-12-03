# LocalStack CI/CD Lab

This repository demonstrates a minimal CI/CD pipeline using:

- Bash scripts
- AWS CLI
- LocalStack (as a safe AWS emulator)

## Pipeline Stages

- Build: Packages a static app into a zip artifact
- Test: Validates artifact and content
- Deploy: Uploads versioned artifacts into S3 (LocalStack)

## Usage

```bash
./pipeline.sh dev
```

## This deploys to
s3://c3-lab-dev-bucket

## Prerequisites
* Docker
* LocalStack
* AWS CLI v2
* Bash
* zip

## Licensed under the MIT License.

Attribution requested:
If you use this project in a public product or educational material,
please cite: "Developed by W. Simpson / SimpsonConcepts".

