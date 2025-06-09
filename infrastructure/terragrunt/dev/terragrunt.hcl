# Dev environment configuration
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../terraform"
}

inputs = {
  environment = "dev"
  aws_account_id = get_aws_account_id()
}