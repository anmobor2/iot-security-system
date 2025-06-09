# Root Terragrunt configuration for backend
remote_state {
  backend = "s3"
  config = {
    bucket         = "iot-security-system-tfstate-${get_aws_account_id()}"
    key            = "iot-security-system/${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "iot-security-system-tfstate-lock"
    encrypt        = true
  }
}

# Generate provider block for AWS
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "eu-west-1"
}
EOF
}