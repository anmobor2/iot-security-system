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