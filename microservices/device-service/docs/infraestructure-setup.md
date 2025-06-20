# Infrastructure Setup with Terraform

This document describes the configuration of the infrastructure for the IoT Security System using Terraform and Terragrunt.

## Overview
The infrastructure includes:
- **Amazon EKS**: Cluster for running the `device-service` microservice.
- **IAM Roles**: For IoT Core, Lambda, and EKS to access other AWS services.
- **Lambda Triggers**:
  - `alert-processor`: Triggered by Kafka (MSK Serverless).
  - `image-processor`: Triggered by S3 object creation events.
- **IoT Core Rules**: Updated to use real ARNs and bootstrap servers.

## Prerequisites
- Terraform 1.5+
- Terragrunt 0.48.0+
- AWS CLI configured
- VPC and subnet IDs (replace placeholders in `terragrunt.hcl`)

## Setup Instructions

1. **Update Terragrunt Configurations**:
   - Replace `vpc_id` and `subnet_ids` in `infrastructure/terragrunt/{dev,staging,prod}/terragrunt.hcl` with real values.
   - Example:
     ```hcl
     vpc_id = "vpc-0abcdef1234567890"
     subnet_ids = ["subnet-0abcdef1234567890", "subnet-1abcdef1234567890"]
     ```

2. **Deploy Infrastructure**:
   ```bash
   cd infrastructure/terragrunt/dev
   terragrunt init
   terragrunt apply
    ```

3. **Deploy Microservice to EKS**:

   - Update `microservices/device-service/kubernetes/deployment.yaml` with the MSK bootstrap servers from Terraform output (`msk_bootstrap_servers`).
   - Configure kubectl to access the EKS cluster:
     ```bash
     aws eks update-kubeconfig --name dev-iot-security-cluster --region us-east-1
     ```
   - Apply Kubernetes manifests:
     ```bash
     kubectl apply -f microservices/device-service/kubernetes/
     ```
4. **Retrieve Outputs**:

       ```bash
       terragrunt output
       ```

   - Update `microservices/device-service/src/main/resources/application.yml` and `kubernetes/deployment.yaml` with `msk_bootstrap_servers` and `dynamodb_endpoint`.
   - Update `lambdas/alert-processor/lambda_function.py` with `sns_topic_arn`.
   - Update `lambdas/image-processor/lambda_function.py` with `dynamodb_table` and `s3_bucket`.

## Notes

- Placeholders for `vpc_id` and `subnet_ids` must be replaced before applying.
- LocalStack will be used in Step 10 to simulate AWS services for testing.
- Ensure certificates from Step 3 are saved in `certs/` for device testing.




