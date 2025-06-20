output "alert_processor_arn" {
  description = "ARN of the alert-processor Lambda"
  value       = aws_lambda_function.alert_processor.arn
}

output "image_processor_arn" {
  description = "ARN of the image-processor Lambda"
  value       = aws_lambda_function.image_processor.arn
}