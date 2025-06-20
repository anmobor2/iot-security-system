variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "grafana_role_arn" {
  description = "ARN of the IAM role for Grafana"
  type        = string
}