import json
import boto3
import os
import logging
from datetime import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

rekognition_client = boto3.client('rekognition')
dynamodb_client = boto3.resource('dynamodb')
table_name = os.environ.get('DYNAMODB_TABLE', 'Events')
bucket_name = os.environ.get('S3_BUCKET', 'iot-security-images')

def lambda_handler(event, context):
    try:
        for record in event['Records']:
            s3_bucket = record['s3']['bucket']['name']
            s3_key = record['s3']['object']['key']
            process_image(s3_bucket, s3_key)
        return {
            'statusCode': 200,
            'body': json.dumps('Processed images successfully')
        }
    except Exception as e:
        logger.error(f"Error processing image: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error: {str(e)}")
        }

def process_image(bucket, key):
    # Detect faces using Rekognition
    response = rekognition_client.detect_faces(
        Image={
            'S3Object': {
                'Bucket': bucket,
                'Name': key
            }
        },
        Attributes=['ALL']
    )

    # Extract results
    face_count = len(response['FaceDetails'])
    details = json.dumps(response['FaceDetails'])

    # Save to DynamoDB
    table = dynamodb_client.Table(table_name)
    event = {
        'deviceId': key.split('/')[1],  # Assuming key format: images/<deviceId>/<timestamp>.jpg
        'timestamp': datetime.utcnow().isoformat(),
        'eventType': 'face_detected',
        'details': details if face_count > 0 else '{}'
    }
    table.put_item(Item=event)
    logger.info(f"Saved event to DynamoDB: {event}")