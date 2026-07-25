resource "aws_secretsmanager_secret" "catalog_db_secret" {
  name        = "catalog-db-secret-1"
  description = "MySQL credentials for Catalog microservice"
  recovery_window_in_days = 0

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "catalog_db_secret" {
  secret_id = aws_secretsmanager_secret.catalog_db_secret.id

  secret_string = jsonencode({
    MYSQL_USER     = "mydbadmin"
    MYSQL_PASSWORD = "kalyandb101"
    
    POSTGRESQL_USER     = "mydbadmin"
    POSTGRESQL_PASSWORD = "kalyandb101"
  })
}