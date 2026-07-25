module "sqs" {
  source = "./modules/sqs"
  environment_name = var.environment_name
  
}