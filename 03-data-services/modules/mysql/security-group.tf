resource "aws_security_group" "rds_mysql_sg" {
  name        = "rds-mysql-sg"
  description = "Allow MySQL access from EKS cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name = "rds-mysql-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "mysql_from_eks" {
  security_group_id            = aws_security_group.rds_mysql_sg.id
  referenced_security_group_id = var.eks_security_group_id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  description                  = "Allow MySQL from EKS Cluster"
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.rds_mysql_sg.id
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}