output "thing_name" {
  description = "Name of the IoT Thing"
  value       = aws_iot_thing.test_sensor.name
}

output "certificate_pem" {
  description = "Certificate PEM for the IoT device"
  value       = aws_iot_certificate.device_cert.certificate_pem
  sensitive   = true
}

output "private_key" {
  description = "Private key for the IoT device"
  value       = aws_iot_certificate.device_cert.private_key
  sensitive   = true
}

output "certificate_arn" {
  description = "ARN of the IoT certificate"
  value       = aws_iot_certificate.device_cert.arn
}

output "iot_endpoint" {
  description = "AWS IoT Core endpoint"
  value       = data.aws_iot_endpoint.current.endpoint_address
}

data "aws_iot_endpoint" "current" {
  endpoint_type = "iot:Data-ATS"
}