output "iot_role_arn" {
  description = "ARN of the IAM role for IoT Core"
  value       = aws_iam_role.iot_role.arn
}

output "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda"
  value       = aws_iam_role.lambda_role.arn
}

output "eks_role_arn" {
  description = "ARN of the IAM role for EKS cluster"
  value       = aws_iam_role.eks_role.arn
}

output "eks_node_role_arn" {
  description = "ARN of the IAM role for EKS node group"
  value       = aws_iam_role.eks_node_role.arn
}

output "grafana_role_arn" {
  description = "ARN of the IAM role for Grafana"
  value       = aws_iam_role.grafana_role.arn
}