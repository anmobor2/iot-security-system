import paho.mqtt.client as mqtt
import ssl
import json
import time

# Configuration
endpoint = "<iot-endpoint>"  # e.g., xxxxxxxxxx-ats.iot.us-east-1.amazonaws.com
port = 8883
client_id = "TestSensor"
cert_path = "certs/<id>.certificate.pem.crt"
key_path = "certs/<id>.private.key"
ca_path = "certs/AmazonRootCA1.pem"
topic = "security/sensors/motion"

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

# Publish test message
try:
    while True:
        message = {
            "deviceId": "sensor_001",
            "eventType": "motion",
            "timestamp": time.strftime("%Y-%m-%dT%H:%M:%S"),
            "details": "{}"
        }
        client.publish(topic, json.dumps(message), qos=1)
        print(f"Published: {message}")
        time.sleep(5)  # Publish every 5 seconds
except KeyboardInterrupt:
    print("Stopping...")
    client.loop_stop()
    client.disconnect()