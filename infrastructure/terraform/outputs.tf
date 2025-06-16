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