output "rds_address" {
  value = module.mysql.rds_address
}

output "checkout_redis_endpoint" {
  value = module.elasticache.checkout_redis_endpoint
}


output "orders_sqs_queue_url" {
  description = "SQS Queue URL for Orders microservice"
  value       = module.sqs.orders_sqs_queue_url
}

output "orders_sqs_queue_arn" {
  description = "SQS Queue ARN for Orders microservice"
  value       = module.sqs.orders_sqs_queue_arn
}



output "orders_rds_postgresql_endpoint" {
  description = "PostgreSQL RDS endpoint for Orders microservice"
  value       = module.postgresql.orders_rds_postgresql_endpoint
}

output "orders_rds_postgresql_db_name" {
  value       = module.postgresql.orders_rds_postgresql_db_name
}

