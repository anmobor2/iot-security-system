# Creating IoT Thing
resource "aws_iot_thing" "test_sensor" {
  name = "${var.environment}-TestSensor"
}

# Creating IoT Policy
resource "aws_iot_policy" "device_policy" {
  name = "${var.environment}-IoTDevicePolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iot:Publish",
          "iot:Subscribe",
          "iot:Connect",
          "iot:Receive"
        ]
        Resource = [
          "arn:aws:iot:${var.aws_region}:${var.aws_account_id}:client/*",
          "arn:aws:iot:${var.aws_region}:${var.aws_account_id}:topic/security/*"
        ]
      }
    ]
  })
}

# Creating IoT Certificate
resource "aws_iot_certificate" "device_cert" {
  active = true
}

# Attaching Policy to Certificate
resource "aws_iot_policy_attachment" "policy_attachment" {
  policy = aws_iot_policy.device_policy.name
  target = aws_iot_certificate.device_cert.arn
}

# Attaching Certificate to Thing
resource "aws_iot_thing_principal_attachment" "thing_attachment" {
  thing    = aws_iot_thing.test_sensor.name
  principal = aws_iot_certificate.device_cert.arn
}

# IoT Rule for Kafka
resource "aws_iot_topic_rule" "route_to_kafka" {
  name        = "${var.environment}_RouteToKafka"
  enabled     = true
  sql         = "SELECT * FROM 'security/sensors/#' WHERE eventType IN ('motion', 'door_open')"
  sql_version = "2016-03-23"

  kafka {
    destination_arn = var.kafka_destination_arn
    topic           = "security.sensors.events"
    client_properties = {
      "bootstrap.servers" = var.kafka_bootstrap_servers
      "security.protocol" = "SASL_SSL"
      "sasl.mechanism"    = "SCRAM-SHA-512"
    }
  }
}

# IoT Rule for SNS
resource "aws_iot_topic_rule" "route_to_sns" {
  name        = "${var.environment}_RouteToSNS"
  enabled     = true
  sql         = "SELECT * FROM 'security/+' WHERE eventType IN ('motion', 'face_detected')"
  sql_version = "2016-03-23"

  sns {
    target_arn = var.sns_topic_arn
    role_arn   = var.iot_role_arn
    message_format = "RAW"
  }
}

# IoT Rule for SQS
resource "aws_iot_topic_rule" "route_to_sqs" {
  name        = "${var.environment}_RouteToSQS"
  enabled     = true
  sql         = "SELECT * FROM 'security/cameras/detection'"
  sql_version = "2016-03-23"

  sqs {
    queue_url = var.sqs_queue_url
    role_arn  = var.iot_role_arn
    use_base64 = false
  }
}

resource "aws_iot_topic_rule" "send_to_kafka" {
  name        = "sendToKafka-${var.environment}"
  description = "Regla IoT que reenvía mensajes a MSK"
  enabled     = true

  sql = "SELECT * FROM 'dispositivos/+/eventos'"

  sql_version = "2016-03-23"

  kafka {
    destination_arn    = var.kafka_destination_arn
    topic              = "iot-events"
    key                = "${topic()}"
    partition          = "0"
    client_properties = {
      "bootstrap.servers" = var.kafka_bootstrap_servers
    }
  }

  role_arn = var.iot_role_arn
}

resource "aws_iot_topic_rule" "complex_rule" {
  name        = "${var.environment}_ComplexRule"
  description = "Regla avanzada: filtra, transforma y enruta a Lambda, S3 y CloudWatch Logs"
  enabled     = true

  sql = <<EOF
    SELECT
      deviceId,
      temperature,
      timestamp(),
      CASE
        WHEN temperature > 80 THEN 'ALERT'
        ELSE 'NORMAL'
      END AS status,
      encode(payload(), 'base64') AS raw_payload
    FROM 'sensors/+/temperature'
    WHERE temperature > 70 AND isUndefined(humidity) = false AND humidity < 30
  EOF

  sql_version = "2016-03-23"

  lambda {
    function_arn = var.lambda_function_arn
    role_arn     = var.iot_role_arn
  }

  s3 {
    bucket_name = var.s3_bucket_name
    key         = "iot/${topic()}/${timestamp()}.json"
    role_arn    = var.iot_role_arn
  }

  cloudwatch_logs {
    log_group_name = var.cw_log_group
    role_arn       = var.iot_role_arn
  }
}