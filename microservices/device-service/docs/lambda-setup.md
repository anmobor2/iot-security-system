# AWS Lambda Setup

This document describes the configuration of AWS Lambda functions for the IoT Security System.

## Overview
Two Lambda functions are implemented:
- **alert-processor**: Processes events from Kafka or IoT Core and sends notifications via SNS.
- **image-processor**: Analyzes images from S3 using Rekognition and saves results to DynamoDB.

## Prerequisites
- Python 3.9+
- AWS CLI configured
- AWS account with IAM credentials (or LocalStack for testing)

## Setup Instructions

1. **Install Dependencies**:
   ```bash
   cd lambdas/alert-processor
   pip install -r requirements.txt -t .
   cd ../image-processor
   pip install -r requirements.txt -t .
   ```

2. **Package Lambdas**:
   ```bash
   cd lambdas/alert-processor
   zip -r alert-processor.zip .
   cd ../image-processor
   zip -r image-processor.zip .
   ```

3. **Deploy Lambdas**:
    - Lambdas will be deployed via Terraform in Step 6.
    - Environment variables (placeholders):
        - `alert-processor`: `SNS_TOPIC_ARN`
        - `image-processor`: `DYNAMODB_TABLE`, `S3_BUCKET`

4. **Test Locally**:
    - Use a tool like `aws-sam-cli` for local testing:
      ```bash
      sam local invoke AlertProcessor -e test_event.json
      ```
    - Example `test_event.json` for `alert-processor`:
      ```json
      {
        "records": {
          "security.sensors.events": [
            {
              "value": "eyJkZXZpY2VJRCI6InNlbnNvcl8wMDEiLCJldmVudFR5cGUiOiJtb3Rpb24iLCJ0aW1lc3RhbXAiOiIyMDI1LTA2LTA5VDEyOjAwOjAwIiwiZGV0YWlscyI6Int9In0="
            }
          ]
        }
      }
      ```

## Notes
- SNS, SQS, S3, DynamoDB, and MSK resources will be configured in Step 5.
- IAM roles and triggers will be created in Step 6.
- LocalStack can be used for end-to-end testing in Step 10.