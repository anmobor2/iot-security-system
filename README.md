# IoT Security System

This project is a proof of concept (PoC) for a global IoT security system, integrating anti-theft alarms and security cameras. It uses AWS services, microservices in Java, Lambda functions in Python, and a DevOps pipeline with GitHub Actions.

## Architecture
- **Devices**: IoT sensors (motion, door/window) and cameras publish events to AWS IoT Core.
- **AWS IoT Core**: Manages device communication via MQTT.
- **Microservice (Java)**: Runs on Amazon EKS, consumes events from Kafka, and manages devices/events.
- **Lambdas (Python)**: Process events for alerts (SNS) and image analysis (Rekognition).
- **Amazon MSK Serverless**: Handles high-volume event streaming.
- **Amazon SNS/SQS**: Manages notifications and asynchronous tasks.
- **Storage**: DynamoDB for events, S3 for images/videos.
- **Infrastructure**: Defined with Terraform.
- **CI/CD**: GitHub Actions for building, testing, and deploying.

## Prerequisites
- Java 17 (OpenJDK)
- Maven 3.8+
- Python 3.9+
- Terraform 1.5+
- Helm 3.10+
- kubectl 1.27+
- AWS CLI 2.x
- Docker
- Git
- AWS account with IAM credentials

## Setup Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/iot-security-system.git
   cd iot-security-system
   ```
2. Configure AWS CLI:
   ```bash
   aws configure
   ```
3. Install dependencies for the microservice:
   ```bash
   cd microservices/device-service
   mvn clean install
   ```
4. Follow subsequent steps in the documentation (see `docs/`).

## Project Structure
```
iot-security-system/
├── microservices/          # Java microservices
├── lambdas/               # Python Lambda functions
├── infrastructure/        # Terraform and Kubernetes configs
├── scripts/               # Device simulation scripts
├── .github/workflows/     # GitHub Actions pipelines
├── docs/                  # Documentation
├── .gitignore
├── README.md
└── LICENSE
```

## Next Steps
- Follow the step-by-step guide in the documentation to set up AWS IoT Core, deploy the microservice to EKS, configure MSK, and more.

## License
MIT License