# DevOps Pipeline Setup

This document describes the configuration of the CI/CD pipeline for the IoT Security System using GitHub Actions.

## Overview
The pipeline includes two workflows:
- **CI/CD Pipeline** (`ci-cd.yml`): Builds, tests, analyzes, and deploys the microservice and Lambda functions using Helm.
- **Terraform Apply** (`terraform-apply.yml`): Applies the infrastructure using Terraform/Terragrunt.

## CI/CD Pipeline Details
- **Trigger**: Push or pull request to `master`.
- **Jobs**:
    - **build**: Compiles the `device-service` microservice with Maven.
    - **test**: Runs unit tests for the microservice.
    - **sonarqube**: Analyzes code quality with SonarQube.
    - **owasp**: Checks for vulnerabilities in dependencies using OWASP Dependency-Check.
    - **trivy**: Scans the Docker image for vulnerabilities using Trivy.
    - **package-lambdas**: Packages `alert-processor` and `image-processor` Lambdas as ZIP.
    - **deploy**: Builds/pushes Docker image to ECR and deploys to EKS using a Helm release.
    - **notify-slack**: Sends pipeline results to Slack.

## Prerequisites
- GitHub repository with push access
- AWS CLI configured (or LocalStack for testing)
- SonarQube server (or simulated in LocalStack)
- Slack workspace with a bot token
- Helm 3.14.0+ installed for deployment
- Secrets configured in GitHub:
    - `AWS_ACCESS_KEY_ID`: Simulated AWS access key (for LocalStack).
    - `AWS_SECRET_ACCESS_KEY`: Simulated AWS secret key (for LocalStack).
    - `SONAR_TOKEN`: SonarQube access token.
    - `SONAR_HOST_URL`: SonarQube server URL.
    - `SLACK_BOT_TOKEN`: Slack bot token.
    - `SLACK_CHANNEL_ID`: Slack channel ID for notifications.

## Setup Instructions

1. **Configure Secrets**:
    - In the GitHub repository, go to Settings > Secrets and variables > Actions.
    - Add:
        - `AWS_ACCESS_KEY_ID`: `test` (for LocalStack).
        - `AWS_SECRET_ACCESS_KEY`: `test` (for LocalStack).
        - `SONAR_TOKEN`: SonarQube token (or placeholder for testing).
        - `SONAR_HOST_URL`: SonarQube URL (e.g., `http://localhost:9000` for local SonarQube).
        - `SLACK_BOT_TOKEN`: Slack bot token (e.g., `xoxb-...`).
        - `SLACK_CHANNEL_ID`: Slack channel ID (e.g., `C12345678`).

2. **Run Pipeline**:
    - Push changes to `master` to trigger the pipeline.
    - Check GitHub Actions for build, test, analysis, and deployment status.
    - Review SonarQube, OWASP, and Trivy reports in artifacts or SonarQube dashboard.
    - Verify Slack notifications in the configured channel.
    - Confirm Helm release (`device-service`) in EKS namespace `iot-security`.

3. **Testing with LocalStack**:
    - In Step 10, configure LocalStack to simulate AWS services (ECR, EKS, etc.).
    - Update `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` with LocalStack credentials.
    - Replace `vpc_id` and `subnet_ids` in `terragrunt.hcl` with simulated values.
    - Simulate SonarQube locally if needed.

## Helm Chart
- **Location**: `microservices/device-service/chart`
- **Name**: `device-service`
- **Version**: `0.1.0`
- **Resources**: Deployment and Service for the microservice.
- **Values**: Configurable in `values.yaml` (image, env, resources, etc.).
- **Deployment**: Installed/updated via `helm upgrade --install` in the pipeline.

## Notes
- The pipeline uses `eu-west-1` as the AWS region.
- Placeholders (`vpc_id`, `subnet_ids`, `KAFKA_BOOTSTRAP_SERVERS`) will be resolved in Step 10 with LocalStack.
- Ensure `certs/` contains IoT Core certificates for device testing.
- SonarQube, OWASP, and Trivy reports are uploaded as artifacts for review.
- Slack notifications include pipeline status and analysis results.