output "msk_cluster_arn" {
  description = "ARN of the MSK Serverless cluster"
  value       = module.msk.msk_cluster_arn
}

output "msk_bootstrap_servers" {
  description = "Bootstrap servers for MSK"
  value       = module.msk.msk_bootstrap_servers
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = module.sns_sqs.sns_topic_arn
}

output "sqs_queue_url" {
  description = "URL of the SQS queue"
  value       = module.sns_sqs.sqs_queue_url
}

output "dynamodb_devices_table" {
  description = "Name of the Devices DynamoDB table"
  value       = module.dynamodb.devices_table_name
}

output "dynamodb_events_table" {
  description = "Name of the Events DynamoDB table"
  value       = module.dynamodb.events_table_name
}

output "s3_bucket_id" {
  description = "ID of the S3 bucket"
  value       = module.s3.bucket_id
}

output "iot_thing_name" {
  description = "Name of the IoT Thing"
  value       = module.iot_core.thing_name
}

output "iot_certificate_pem" {
  description = "Certificate PEM for the IoT device"
  value       = module.iot_core.certificate_pem
  sensitive   = true
}

output "iot_private_key" {
  description = "Private key for the IoT device"
  value       = module.iot_core.private_key
  sensitive   = true
}

output "iot_certificate_arn" {
  description = "ARN of the IoT certificate"
  value       = module.iot_core.certificate_arn
}

output "iot_endpoint" {
  description = "AWS IoT Core endpoint"
  value       = module.iot_core.iot_endpoint
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks.eks_cluster_endpoint
}

output "lambda_alert_processor_arn" {
  description = "ARN of the alert-processor Lambda"
  value       = module.lambda.alert_processor_arn
}

output "lambda_image_processor_arn" {
  description = "ARN of the image-processor Lambda"
  value       = module.lambda.image_processor_arn
}