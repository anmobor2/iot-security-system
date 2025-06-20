# Alert Processor Lambda
resource "aws_lambda_function" "alert_processor" {
  function_name = "${var.environment}-alert-processor"
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = "${path.module}/../../../lambdas/alert-processor/alert-processor.zip"
  source_code_hash = filebase64sha256("${path.module}/../../../lambdas/alert-processor/alert-processor.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}

# Image Processor Lambda
resource "aws_lambda_function" "image_processor" {
  function_name = "${var.environment}-image-processor"
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = "${path.module}/../../../lambdas/image-processor/image-processor.zip"
  source_code_hash = filebase64sha256("${path.module}/../../../lambdas/image-processor/image-processor.zip")

  environment {
    variables = {
      DYNAMODB_TABLE = "${var.environment}-Events"
      S3_BUCKET      = "${var.environment}-iot-security-images"
    }
  }
}

# Lambda Permission for S3 Trigger
resource "aws_lambda_permission" "s3_trigger_permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

# S3 Notification for Image Processor
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "images/"
  }
}

# Lambda Event Source Mapping for Kafka
resource "aws_lambda_event_source_mapping" "kafka_trigger" {
  function_name     = aws_lambda_function.alert_processor.arn
  event_source_arn  = var.kafka_destination_arn
  starting_position = "TRIM_HORIZON"
}