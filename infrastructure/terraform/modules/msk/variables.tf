variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for MSK"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for MSK"
  type        = list(string)
}