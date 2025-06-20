# Architecture

## Diagram
![Architecture Diagram](architecture.png)

## Components
- **Devices**: Simulated sensors (motion, door) and cameras publish events to AWS IoT Core via MQTT.
- **AWS IoT Core**: Manages device connections and routes events to MSK, SNS, and SQS.
- **MSK (Kafka)**: Streams events to the microservice (`security.sensors.events`).
- **SNS**: Sends real-time notifications for critical events.
- **SQS**: Queues asynchronous tasks (e.g., camera metadata processing).
- **Microservice**: `device-service` (Java, Spring Boot) consumes Kafka events, stores in DynamoDB, and exposes REST APIs.
- **Lambdas**:
    - `alert-processor`: Processes events from Kafka/IoT Core, sends alerts via SNS.
    - `image-processor`: Analyzes S3 images with Rekognition, stores results in DynamoDB.
- **DynamoDB**: Stores devices (`dev-Devices`) and events (`dev-Events`).
- **S3**: Stores camera images/videos (`dev-iot-security-images`).
- **EKS**: Hosts the microservice in namespace `iot-security`, deployed via Helm.
- **CloudWatch**: Collects metrics (e.g., `ConnectedDevices`, `Lambda Errors`) and logs.
- **Grafana**: Visualizes CloudWatch metrics in a dashboard.
- **QuickSight** (Optional): Visualizes DynamoDB events via Athena.
- **CI/CD**: GitHub Actions pipeline with build, test, SonarQube, OWASP, Trivy, and Slack notifications.