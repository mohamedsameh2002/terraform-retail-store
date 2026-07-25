resource "aws_db_subnet_group" "rds_postgresql_subnet_group" {
  name       = "rds-postgresql-subnet-group"
  description = "Subnet group for Orders RDS PostgreSQL"
  subnet_ids  = var.private_subnet_ids
  tags = {
    Name = "rds-postgresql-subnet-group"
  }
}
