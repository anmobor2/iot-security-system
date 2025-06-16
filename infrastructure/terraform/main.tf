



module "iot_core" {
  source           = "./modules/iot-core"
  environment      = var.environment
  aws_region       = var.aws_region
  aws_account_id   = var.aws_account_id
  kafka_destination_arn = var.kafka_destination_arn
  kafka_bootstrap_servers = var.kafka_bootstrap_servers
  sns_topic_arn    = var.sns_topic_arn
  sqs_queue_url    = var.sqs_queue_url
  iot_role_arn     = var.iot_role_arn
}