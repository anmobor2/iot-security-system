variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for MSK and EKS"
  type        = string
  default     = "vpc-12345678" # Placeholder
}

variable "subnet_ids" {
  description = "Subnet IDs for MSK and EKS"
  type        = list(string)
  default     = ["subnet-12345678", "subnet-87654321"] # Placeholder
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
  default     = "placeholder-password"
}

variable "quicksight_user_arn" {
  description = "ARN of the QuickSight user"
  type        = string
  default     = "arn:aws:quicksight:eu-west-1:123456789012:user/default/admin"
}

variable "grafana_role_arn" {
  description = "ARN of the IAM role for Grafana"
  type        = string
  default     = "arn:aws:iam::123456789012:role/dev-GrafanaRole"
}