# RDS PostgreSQL Instance
resource "aws_db_instance" "orders_postgres" {
  identifier              = "orders-postgres-db"
  engine                  = "postgres"
  engine_version          = "17.6"
  instance_class          = "db.t4g.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100
  db_subnet_group_name    = aws_db_subnet_group.rds_postgresql_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_postgresql_sg.id]

  db_name                 = "ordersdb"
  username                = var.username # Getting from c6_03 and AWS Secret Manager secret "retailstore-db-secret-1"
  password                = var.password # Getting from c6_03 and AWS Secret Manager secret "retailstore-db-secret-1"
  port                    = 5432

  multi_az                = false
  storage_encrypted       = true
  publicly_accessible     = false
  skip_final_snapshot     = true

  backup_retention_period = 7
  deletion_protection     = false

  tags = {
    Name = "orders-rds-postgres"
    Environment = var.environment_name
  }
}

# Outputs for RDS endpoint and credentials
