# Creating SNS Topic
resource "aws_sns_topic" "security_alerts" {
  name = "${var.environment}-SecurityAlerts"
}

# Creating SQS Queue
resource "aws_sqs_queue" "camera_tasks" {
  name                      = "${var.environment}-CameraTasks"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 10
}

# SNS Subscription to SQS (optional, for testing)
resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.camera_tasks.arn
}

# SQS Policy to allow SNS to publish
resource "aws_sqs_queue_policy" "sns_to_sqs_policy" {
  queue_url = aws_sqs_queue.camera_tasks.id
  policy    = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.camera_tasks.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.security_alerts.arn
          }
        }
      }
    ]
  })
}