import json
import boto3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

sns_client = boto3.client('sns')
sns_topic_arn = os.environ.get('SNS_TOPIC_ARN', 'arn:aws:sns:eu-west-1:123456789012:dev-SecurityAlerts')

def lambda_handler(event, context):
    try:
        # Event may come from Kafka or IoT Core
        for record in event.get('records', {}).get('security.sensors.events', []):
            # Decode Kafka message (base64 encoded)
            message = json.loads(record['value'].decode('utf-8'))
            process_event(message)
        # Direct IoT Core event
        if 'deviceId' in event:
            process_event(event)
        return {
            'statusCode': 200,
            'body': json.dumps('Processed events successfully')
        }
    except Exception as e:
        logger.error(f"Error processing event: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error: {str(e)}")
        }

def process_event(message):
    device_id = message.get('deviceId')
    event_type = message.get('eventType')
    timestamp = message.get('timestamp')
    details = message.get('details', '{}')

    # Example: Send alert for motion or face_detected events
    if event_type in ['motion', 'face_detected']:
        alert_message = f"Alert: {event_type} detected by {device_id} at {timestamp}. Details: {details}"
        sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=alert_message,
            Subject=f"Security Alert: {event_type}"
        )
        logger.info(f"Published alert to SNS: {alert_message}")