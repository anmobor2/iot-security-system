# Dev environment configuration
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../terraform"
}

inputs = {
  environment      = "dev"
  aws_account_id   = get_aws_account_id()
  aws_region       = "eu-west-1"
  kafka_destination_arn = "arn:aws:kafka:eu-west-1:${get_aws_account_id()}:cluster/placeholder"
  kafka_bootstrap_servers = "replace-with-msk-bootstrap-servers"
  sns_topic_arn    = "arn:aws:sns:eu-west-1:${get_aws_account_id()}:SecurityAlerts"
  sqs_queue_url    = "https://sqs.eu-west-1.amazonaws.com/${get_aws_account_id()}/CameraTasks"
  iot_role_arn     = "arn:aws:iam::${get_aws_account_id()}:role/IoTRole"
}