variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for alarms"
  type        = string
}