resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "elasticache-subnets"
  subnet_ids = var.private_subnet_ids
}
