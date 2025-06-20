import paho.mqtt.client as mqtt
import ssl
import json
import time
import random
import os

# Configuration
endpoint = "<iot-endpoint>"  # e.g., xxxxxxxxxx-ats.iot.eu-west-1.amazonaws.com
port = 8883
client_id = "SimulatedSensor"
cert_path = "certs/device_certificate.pem"
key_path = "certs/device_private_key.key"
ca_path = "certs/AmazonRootCA1.pem"
topics = ["security/sensors/motion", "security/sensors/door"]

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

# Simulate sensor events
try:
    while True:
        # Randomly choose a topic and device
        topic = random.choice(topics)
        device_id = f"{topic.split('/')[-1]}_{random.randint(1, 100):03d}"
        event_type = "motion" if topic.endswith("motion") else "door_open"

        message = {
            "deviceId": device_id,
            "eventType": event_type,
            "timestamp": time.strftime("%Y-%m-%dT%H:%M:%S"),
            "details": "{}"
        }

        client.publish(topic, json.dumps(message), qos=1)
        print(f"Published to {topic}: {message}")
        time.sleep(random.randint(3, 10))  # Random delay
except KeyboardInterrupt:
    print("Stopping...")
    client.loop_stop()
    client.disconnect()