# AWS IoT Core Setup with Terraform

This document describes the configuration of AWS IoT Core for the IoT Security System using Terraform.

## Prerequisites
- AWS account with IAM credentials.
- Terraform 1.5+ and Terragrunt 0.48.0+ installed.
- AWS CLI configured.
- Amazon Root CA downloaded (`AmazonRootCA1.pem`).

## Configuration Steps

1. **Deploy IoT Core with Terraform**:
    - Navigate to the desired environment:
      ```bash
      cd infrastructure/terragrunt/dev
      ```
    - Initialize Terragrunt:
      ```bash
      terragrunt init
      ```
    - Apply the configuration:
      ```bash
      terragrunt apply
      ```
    - This creates:
        - IoT Thing: `dev-TestSensor`
        - IoT Policy: `dev-IoTDevicePolicy`
        - IoT Certificate and attachments
        - IoT Rules: `dev_RouteToKafka`, `dev_RouteToSNS`, `dev_RouteToSQS` (disabled until MSK/SNS/SQS are configured)

2. **Retrieve Outputs**:
    - After applying, note the Terraform outputs:
        - `iot_endpoint`: AWS IoT Core endpoint
        - `iot_certificate_pem`: Certificate PEM
        - `iot_private_key`: Private key
    - Save the certificate and private key to `certs/`:
      ```bash
      mkdir -p certs
      echo "<certificate-pem>" > certs/device_certificate.pem
      echo "<private-key>" > certs/device_private_key.key
      ```

3. **IoT Configuration**:
    - **Thing**: Represents a device (`TestSensor`).
    - **Policy**: Allows publish/subscribe on `security/*` topics.
    - **Rules**:
        - `RouteToKafka`: Routes `security/sensors/#` (motion, door_open) to Kafka topic `security.sensors.events`.
        - `RouteToSNS`: Routes `security/+` (motion, face_detected) to SNS topic.
        - `RouteToSQS`: Routes `security/cameras/detection` to SQS queue.

## Testing
1. Install dependencies:
   ```bash
   pip install paho-mqtt
   ```
2. Update `scripts/mqtt-client-test.py` with:
    - IoT endpoint from Terraform output (`iot_endpoint`).
    - Paths to certificate, key, and CA files.
3. Run the script:
   ```bash
   python scripts/mqtt-client-test.py
   ```
4. Verify messages in the AWS IoT Core Test Client:
    - In AWS IoT Core > Test > MQTT test client, subscribe to `security/#` and check for published messages.

## Notes
- Kafka, SNS, and SQS resources will be configured in Step 5.
- IAM roles for rules will be created in Step 6.
- Rules are disabled (`enabled = false`) until dependent resources are available.