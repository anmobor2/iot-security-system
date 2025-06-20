variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket for Athena results"
  type        = string
}

variable "quicksight_username" {
  description = "QuickSight username"
  type        = string
  default     = "admin"
}

variable "quicksight_password" {
  description = "QuickSight password"
  type        = string
  sensitive   = true
}

variable "quicksight_user_arn" {
  description = "ARN of the QuickSight user"
  type        = string
}