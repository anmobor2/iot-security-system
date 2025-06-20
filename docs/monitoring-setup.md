# Monitoring and Visualization Setup

This document describes the configuration of monitoring and visualization for the IoT Security System using CloudWatch and QuickSight.

## Overview
- **CloudWatch**: Collects metrics, logs, and alarms for IoT Core, EKS, Lambda, MSK, SNS, and SQS.
- **QuickSight** (Optional): Visualizes security events from DynamoDB via Athena.

## Prerequisites
- Terraform 1.5+
- Terragrunt 0.48.0+
- AWS CLI configured (or LocalStack for testing)
- SNS topic (`dev-SecurityAlerts`) for alarm notifications
- QuickSight account (optional, for real AWS testing)

## Setup Instructions

1. **Deploy CloudWatch and QuickSight**:
   ```bash
   cd infrastructure/terragrunt/dev
   terragrunt init
   terragrunt plan
   ```
    - Note: Apply will be tested in Step 10 with LocalStack.

2. **CloudWatch Configuration**:
    - **Log Groups**:
        - `/aws/lambda/dev-alert-processor`
        - `/aws/lambda/dev-image-processor`
        - `/iot-security/device-service`
    - **Alarms**:
        - `dev-alert-processor-errors`: Triggers on Lambda errors.
        - `dev-image-processor-errors`: Triggers on Lambda errors.
        - `dev-iot-disconnected-devices`: Triggers when no devices are connected.
    - Notifications sent to SNS topic `dev-SecurityAlerts`.

3. **QuickSight Configuration (Optional)**:
    - Creates an Athena workgroup and QuickSight data source, dataset, analysis, and dashboard.
    - Visualizes events from DynamoDB table `dev-Events`.
    - Requires valid QuickSight credentials (`quicksight_username`, `quicksight_password`, `quicksight_user_arn`).

4. **Verify Monitoring**:
    - Check CloudWatch logs and metrics in AWS Console or LocalStack.
    - View QuickSight dashboard (if deployed) for event visualizations.

## Notes
- Uses `eu-west-1` as the AWS region.
- Placeholders (`vpc_id`, `subnet_ids`, `quicksight_user_arn`) will be resolved in Step 10 with LocalStack.
- QuickSight is optional and may not be fully supported in LocalStack.