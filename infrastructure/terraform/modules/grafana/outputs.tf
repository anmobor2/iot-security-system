output "grafana_workspace_id" {
  description = "ID of the Grafana workspace"
  value       = aws_grafana_workspace.iot_security.id
}

output "grafana_workspace_endpoint" {
  description = "Endpoint of the Grafana workspace"
  value       = aws_grafana_workspace.iot_security.endpoint
}