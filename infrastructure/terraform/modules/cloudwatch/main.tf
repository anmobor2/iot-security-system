# CloudWatch Log Groups for Lambda
resource "aws_cloudwatch_log_group" "alert_processor_log_group" {
  name              = "/aws/lambda/${var.environment}-alert-processor"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "image_processor_log_group" {
  name              = "/aws/lambda/${var.environment}-image-processor"
  retention_in_days = 14
}

# CloudWatch Log Group for Microservice
resource "aws_cloudwatch_log_group" "device_service_log_group" {
  name              = "/iot-security/device-service"
  retention_in_days = 14
}

# CloudWatch Metric Alarm for Lambda Errors
resource "aws_cloudwatch_metric_alarm" "alert_processor_errors" {
  alarm_name          = "${var.environment}-alert-processor-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alarm when alert-processor Lambda has errors"
  alarm_actions       = [var.sns_topic_arn]
  dimensions = {
    FunctionName = "${var.environment}-alert-processor"
  }
}

resource "aws_cloudwatch_metric_alarm" "image_processor_errors" {
  alarm_name          = "${var.environment}-image-processor-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alarm when image-processor Lambda has errors"
  alarm_actions       = [var.sns_topic_arn]
  dimensions = {
    FunctionName = "${var.environment}-image-processor"
  }
}

# CloudWatch Metric Alarm for IoT Core Disconnected Devices
resource "aws_cloudwatch_metric_alarm" "iot_disconnected_devices" {
  alarm_name          = "${var.environment}-iot-disconnected-devices"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ConnectedDevices"
  namespace           = "AWS/IoT"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Alarm when IoT devices are disconnected"
  alarm_actions       = [var.sns_topic_arn]
}