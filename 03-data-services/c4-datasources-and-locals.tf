data "aws_secretsmanager_secret" "db" {
  name = "catalog-db-secret-1"
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = data.aws_secretsmanager_secret.db.id
}

locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}