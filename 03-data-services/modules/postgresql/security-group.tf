# Security Group for RDS PostgreSQL
# Allow access only from EKS Cluster security group
resource "aws_security_group" "rds_postgresql_sg" {
  name        = "rds-postgresql-sg"
  description = "Allow RDS PostgreSQL access from EKS cluster"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow RDS PostgreSQL from EKS Cluster"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups  = [var.eks_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

