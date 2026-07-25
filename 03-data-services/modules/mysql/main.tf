resource "aws_db_instance" "mysql" {
  identifier = "mydb3"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = var.instance_class

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "mydb"
  username = var.username
  password = var.password

  db_subnet_group_name   = aws_db_subnet_group.rds_private_subnets.name
  vpc_security_group_ids = [aws_security_group.rds_mysql_sg.id]

  publicly_accessible = false

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "mydb3"
  }
}