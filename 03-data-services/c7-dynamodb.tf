module "dynamodb" {
    source = "./modules/dynamodb"
    environment_name = var.environment_name

}