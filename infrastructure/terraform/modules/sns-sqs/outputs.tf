output "msk_cluster_arn" {
  description = "ARN of the MSK Serverless cluster"
  value       = aws_msk_serverless_cluster.msk_cluster.arn
}

output "msk_bootstrap_servers" {
  description = "Bootstrap servers for MSK"
  value       = aws_msk_serverless_cluster.msk_cluster.client_authentication[0].sasl[0].iam[0].bootstrap_brokers_sasl_iam
}