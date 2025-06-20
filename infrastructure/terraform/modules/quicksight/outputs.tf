output "dashboard_id" {
  description = "ID of the QuickSight dashboard"
  value       = aws_quicksight_dashboard.iot_security_dashboard.dashboard_id
}