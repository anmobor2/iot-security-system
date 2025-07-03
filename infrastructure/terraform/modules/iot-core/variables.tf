variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "kafka_destination_arn" {
  description = "ARN of the Kafka destination (MSK)"
  type        = string
  default     = "arn:aws:kafka:us-east-1:123456789012:cluster/placeholder"
}

variable "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers"
  type        = string
  default     = "replace-with-msk-bootstrap-servers"
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
  default     = "arn:aws:sns:us-east-1:123456789012:SecurityAlerts"
}

variable "sqs_queue_url" {
  description = "URL of the SQS queue"
  type        = string
  default     = "https://sqs.us-east-1.amazonaws.com/123456789012/CameraTasks"
}

variable "iot_role_arn" {
  description = "ARN of the IAM role for IoT rules"
  type        = string
  default     = "arn:aws:iam::123456789012:role/IoTRole"
}

variable "lambda_function_arn" {
  default = ""
}
variable "s3_bucket_name" {
  default = ""
}
variable "cw_log_group" {
  default = ""
}