
resource "aws_security_group" "elasticache_sg" {
  name        = "elasticache-sg"
  description = "Allow EKS cluster to access ElastiCache Redis"
  vpc_id      = var.vpc_id

  ingress {
    from_port                = 6379
    to_port                  = 6379
    protocol                 = "tcp"
    security_groups          = [var.eks_security_group_id]
    description              = "Allow traffic from EKS cluster SG"
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
