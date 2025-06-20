module "msk" {
  source      = "./modules/msk"
  environment = var.environment
  vpc_id      = var.vpc_id
  subnet_ids  = var.subnet_ids
}

module "sns_sqs" {
  source      = "./modules/sns-sqs"
  environment = var.environment
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  environment = var.environment
}

module "s3" {
  source      = "./modules/s3"
  environment = var.environment
}

module "iam" {
  source          = "./modules/iam"
  environment     = var.environment
  aws_region      = var.aws_region
  aws_account_id  = var.aws_account_id
  msk_cluster_arn = module.msk.msk_cluster_arn
  sns_topic_arn   = module.sns_sqs.sns_topic_arn
  sqs_queue_arn   = module.sns_sqs.sqs_queue_arn
}

module "iot_core" {
  source                = "./modules/iot-core"
  environment           = var.environment
  aws_region            = var.aws_region
  aws_account_id        = var.aws_account_id
  kafka_destination_arn = module.msk.msk_cluster_arn
  kafka_bootstrap_servers = module.msk.msk_bootstrap_servers
  sns_topic_arn         = module.sns_sqs.sns_topic_arn
  sqs_queue_url         = module.sns_sqs.sqs_queue_url
  iot_role_arn          = module.iam.iot_role_arn
}

module "lambda" {
  source                = "./modules/lambda"
  environment           = var.environment
  lambda_role_arn       = module.iam.lambda_role_arn
  sns_topic_arn         = module.sns_sqs.sns_topic_arn
  s3_bucket_arn         = module.s3.bucket_arn
  s3_bucket_id          = module.s3.bucket_id
  kafka_destination_arn = module.msk.msk_cluster_arn
}

module "eks" {
  source             = "./modules/eks"
  environment        = var.environment
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  eks_role_arn       = module.iam.eks_role_arn
  eks_node_role_arn  = module.iam.eks_node_role_arn
}