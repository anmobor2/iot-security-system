#!/bin/bash

docker rm -f localstack 2>/dev/null

# Start LocalStack with required services
docker run -d \
  -p 4566:4566 \
  -e SERVICES="iot,eks,kafka,sns,sqs,dynamodb,s3,lambda,cloudwatch,athena,quicksight,grafana" \
  -e AWS_DEFAULT_REGION="eu-west-1" \
  -e LOCALSTACK_HOSTNAME="localhost" \
  -v $(pwd)/certs:/certs \
  --name localstack \
  localstack/localstack:3.8

# Wait for LocalStack to start
echo "Waiting for LocalStack to start..."
sleep 10

# Configure AWS CLI for LocalStack
aws configure set aws_access_key_id test
aws configure set aws_secret_access_key test
aws configure set region eu-west-1
aws configure set endpoint_url http://localhost:4566

# Run initialization script
python $(dirname "$0")/localstack_init.py