# Testing Guide

This guide outlines how to test the IoT Security System using LocalStack.

## Prerequisites
- LocalStack running (`./scripts/localstack_setup.sh`)
- Infrastructure deployed (`terragrunt apply`)
- Certificates in `certs/` from `localstack_init.py`
- Dependencies installed (`paho-mqtt`, `boto3`, `Pillow`)

## Test Steps

1. **Start LocalStack**:
   ```bash
   ./scripts/localstack_setup.sh
   ```

2. **Deploy Infrastructure**:
   ```bash
   cd infrastructure/terragrunt/dev
   terragrunt init
   terragrunt apply
   ```

3. **Run Pipeline**:
    - Push to `master` to trigger `.github/workflows/ci-cd.yml`.
    - Verify microservice deployment in EKS (namespace `iot-security`).

4. **Simulate Devices**:
    - Update `simulate-sensor.py` and `simulate-camera.py` with IoT endpoint.
    - Run:
      ```bash
      python scripts/simulate-sensor.py
      python scripts/simulate-camera.py
      ```

5. **Verify Flow**:
    - **IoT Core**: Subscribe to `security/#` at `http://localhost:4566`.
    - **DynamoDB**: Check `dev-Events`:
      ```bash
      aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name dev-Events
      ```
    - **S3**: List images in `dev-iot-security-images`:
      ```bash
      aws --endpoint-url=http://localhost:4566 s3 ls s3://dev-iot-security-images/
      ```
    - **CloudWatch**: Check metrics and logs:
      ```bash
      aws --endpoint-url=http://localhost:4566 cloudwatch list-metrics --namespace AWS/IoT
      aws --endpoint-url=http://localhost:4566 logs get-log-events --log-group-name /aws/lambda/dev-alert-processor
      ```
    - **Grafana**: View dashboard at `http://localhost:3000`.

## Notes
- Uses `eu-west-1` as the region.
- QuickSight requires a real AWS account.
- Report issues in GitHub Issues.