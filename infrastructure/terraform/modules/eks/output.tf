output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.iot_security_cluster.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = aws_eks_cluster.iot_security_cluster.endpoint
}