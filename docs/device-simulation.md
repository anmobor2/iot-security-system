# Device Simulation Setup

This document describes the configuration of scripts to simulate IoT devices for the IoT Security System.

## Overview
Two scripts simulate IoT devices:
- **simulate-sensor.py**: Simulates motion and door/window sensors, publishing to `security/sensors/motion` and `security/sensors/door`.
- **simulate-camera.py**: Simulates security cameras, publishing to `security/cameras/detection` and uploading images to S3.

## Prerequisites
- Python 3.9+
- AWS CLI configured (or LocalStack for testing)
- IoT Core certificates (`device_certificate.pem`, `device_private_key.key`, `AmazonRootCA1.pem`) from Step 3
- Dependencies: `paho-mqtt`, `boto3`, `Pillow`
- AWS IoT Core endpoint and S3 bucket (`dev-iot-security-images`)

## Setup Instructions

1. **Install Dependencies**:
   ```bash
   pip install paho-mqtt boto3 Pillow
   ```

2. **Configure Scripts**:
    - Update `simulate-sensor.py` and `simulate-camera.py` with:
        - IoT endpoint (from Terraform output `iot_endpoint`).
        - Paths to certificates (`certs/device_certificate.pem`, `certs/device_private_key.key`, `certs/AmazonRootCA1.pem`).
    - For `simulate-camera.py`, ensure AWS credentials are set for S3 access (simulated in LocalStack).

3. **Run Scripts**:
   ```bash
   python scripts/simulate-sensor.py
   python scripts/simulate-camera.py
   ```

4. **Verify Events**:
    - In AWS IoT Core > Test > MQTT test client, subscribe to `security/#` to see published events.
    - Check S3 bucket `dev-iot-security-images` for uploaded images (simulated in LocalStack).
    - Monitor DynamoDB table `dev-Events` for processed events (via Lambda or microservice).

## Notes
- Scripts use `eu-west-1` as the AWS region.
- Testing will be done in Step 10 with LocalStack to simulate IoT Core, S3, and other services.
- Ensure `certs/` contains valid certificates from Step 3.
- Placeholders (e.g., IoT endpoint) will be resolved in Step 10.