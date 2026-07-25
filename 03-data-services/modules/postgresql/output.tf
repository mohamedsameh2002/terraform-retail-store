output "orders_rds_postgresql_endpoint" {
  description = "PostgreSQL RDS endpoint for Orders microservice"
  value       = aws_db_instance.orders_postgres.endpoint
}

output "orders_rds_postgresql_db_name" {
  value       = aws_db_instance.orders_postgres.db_name
}

