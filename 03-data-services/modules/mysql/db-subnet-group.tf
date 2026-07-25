resource "aws_db_subnet_group" "rds_private_subnets" {
  name        = "rds-private-subnets"
  description = "Private subnets for RDS"

  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "rds-private-subnets"
  }
}