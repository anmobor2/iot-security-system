output "alert_processor_log_group_name" {
  description = "Name of the CloudWatch log group for alert-processor"
  value       = aws_cloudwatch_log_group.alert_processor_log_group.name
}

output "image_processor_log_group_name" {
  description = "Name of the CloudWatch log group for image-processor"
  value       = aws_cloudwatch_log_group.image_processor_log_group.name
}

output "device_service_log_group_name" {
  description = "Name of the CloudWatch log group for device-service"
  value       = aws_cloudwatch_log_group.device_service_log_group.name
}