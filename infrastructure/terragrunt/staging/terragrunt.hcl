# Staging environment configuration
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../terraform"
}

inputs = {
  environment           = "staging"
  aws_account_id        = get_aws_account_id()
  aws_region            = "eu-west-1"
  vpc_id                = "vpc-12345678" # Placeholder
  subnet_ids            = ["subnet-12345678", "subnet-87654321"] # Placeholder
  quicksight_username   = "admin"
  quicksight_password   = "placeholder-password"
  quicksight_user_arn   = "arn:aws:quicksight:eu-west-1:${get_aws_account_id()}:user/default/admin"
}