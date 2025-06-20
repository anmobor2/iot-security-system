import paho.mqtt.client as mqtt
import ssl
import json
import time
import random
import boto3
import os
from io import BytesIO
from PIL import Image

# Configuration
endpoint = "iot-endpoint>"  # e.g., xxxxxxxxxx-ats.iot.eu-west-1.amazonaws.com
port = 8883
client_id = "SimulatedCamera"
cert_path = "certs/device_certificate.pem"
key_path = "certs/device_private_key.key"
ca_path = "certs/AmazonRootCA1.pem"
topic = "security/cameras/detection"
s3_bucket = "dev-iot-security-images"
s3_region = "eu-west-1"

# Initialize S3 client
s3_client = boto3.client('s3', region_name=s3_region)

# Callback functions
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to AWS IoT Core")
        client.subscribe("security/#")
    else:
        print(f"Connection failed with code {rc}")

def on_message(client, userdata, msg):
    print(f"Received message on {msg.topic}: {msg.payload.decode()}")

# Create MQTT client
client = mqtt.Client(client_id=client_id)
client.on_connect = on_connect
client.on_message = on_message

# Configure TLS
client.tls_set(
    ca_certs=ca_path,
    certfile=cert_path,
    keyfile=key_path,
    cert_reqs=ssl.CERT_REQUIRED,
    tls_version=ssl.PROTOCOL_TLSv1_2,
    ciphers=None
)

# Connect to AWS IoT Core
client.connect(endpoint, port=port, keepalive=60)

# Start the loop
client.loop_start()

# Simulate camera events
try:
    while True:
        device_id = f"camera_{random.randint(1, 100):03d}"
        timestamp = time.strftime("%Y-%m-%dT%H:%M:%S")
        s3_key = f"images/{device_id}/{timestamp.replace(':', '-')}.jpg"

        # Create a dummy image
        image = Image.new('RGB', (100, 100), color='red')
        buffer = BytesIO()
        image.save(buffer, format="JPEG")
        buffer.seek(0)

        # Upload to S3
        s3_client.put_object(
            Bucket=s3_bucket,
            Key=s3_key,
            Body=buffer,
            ContentType='image/jpeg'
        )
        print(f"Uploaded image to S3: {s3_key}")

        # Publish MQTT event
        message = {
            "deviceId": device_id,
            "eventType": "face_detected",
            "timestamp": timestamp,
            "details": json.dumps({"s3Key": s3_key})
        }

        client.publish(topic, json.dumps(message), qos=1)
        print(f"Published to {topic}: {message}")
        time.sleep(random.randint(5, 15))  # Random delay
except KeyboardInterrupt:
    print("Stopping...")
    client.loop_stop()
    client.disconnect()