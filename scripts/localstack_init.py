import boto3
import json

# Configure boto3 for LocalStack
session = boto3.Session(
    aws_access_key_id='test',
    aws_secret_access_key='test',
    region_name='eu-west-1'
)

# Clients
iot_client = session.client('iot', endpoint_url='http://localhost:4566')
sns_client = session.client('sns', endpoint_url='http://localhost:4566')
sqs_client = session.client('sqs', endpoint_url='http://localhost:4566')
dynamodb_client = session.client('dynamodb', endpoint_url='http://localhost:4566')
s3_client = session.client('s3', endpoint_url='http://localhost:4566')
kafka_client = session.client('kafka', endpoint_url='http://localhost:4566')

# Create IoT Thing
try:
    iot_client.create_thing(thingName='dev-TestSensor')
    cert_response = iot_client.create_keys_and_certificate(setAsActive=True)
    with open('certs/device_certificate.pem', 'w') as f:
        f.write(cert_response['certificatePem'])
    with open('certs/device_private_key.key', 'w') as f:
        f.write(cert_response['keyPair']['PrivateKey'])
    iot_client.attach_thing_principal(
        thingName='dev-TestSensor',
        principal=cert_response['certificateArn']
    )
    iot_client.attach_policy(
        policyName='dev-IoTDevicePolicy',
        target=cert_response['certificateArn']
    )
    print("Created IoT Thing and certificate")
except Exception as e:
    print(f"Error creating IoT resources: {e}")

# Create SNS Topic
try:
    sns_response = sns_client.create_topic(Name='dev-SecurityAlerts')
    print(f"Created SNS topic: {sns_response['TopicArn']}")
except Exception as e:
    print(f"Error creating SNS topic: {e}")

# Create SQS Queue
try:
    sqs_response = sqs_client.create_queue(QueueName='dev-CameraTasks')
    print(f"Created SQS queue: {sqs_response['QueueUrl']}")
except Exception as e:
    print(f"Error creating SQS queue: {e}")

# Create DynamoDB Tables
try:
    dynamodb_client.create_table(
        TableName='dev-Devices',
        KeySchema=[
            {'AttributeName': 'deviceId', 'KeyType': 'HASH'}
        ],
        AttributeDefinitions=[
            {'AttributeName': 'deviceId', 'AttributeType': 'S'}
        ],
        BillingMode='PAY_PER_REQUEST'
    )
    dynamodb_client.create_table(
        TableName='dev-Events',
        KeySchema=[
            {'AttributeName': 'deviceId', 'KeyType': 'HASH'},
            {'AttributeName': 'timestamp', 'KeyType': 'RANGE'}
        ],
        AttributeDefinitions=[
            {'AttributeName': 'deviceId', 'AttributeType': 'S'},
            {'AttributeName': 'timestamp', 'AttributeType': 'S'}
        ],
        BillingMode='PAY_PER_REQUEST'
    )
    print("Created DynamoDB tables")
except Exception as e:
    print(f"Error creating DynamoDB tables: {e}")

# Create S3 Bucket
try:
    s3_client.create_bucket(
        Bucket='dev-iot-security-images',
        CreateBucketConfiguration={'Location': {'type': 'AvailabilityZone', 'value': 'eu-west-1a'}}
    )
    print("Created S3 bucket")
except Exception as e:
    print(f"Error creating S3 bucket: {e}")

# Create Kafka Cluster (simulated)
try:
    kafka_client.create_cluster(
        ClusterName='dev-iot-security-msk',
        NumberOfBrokerNodes=1,
        KafkaVersion='2.8.1'
    )
    print("Created Kafka cluster")
except Exception as e:
    print(f"Error creating Kafka cluster: {e}")