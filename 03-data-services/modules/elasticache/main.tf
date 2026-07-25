# AWS Elastic Cache Redis Cluster
resource "aws_elasticache_cluster" "checkout_elasticache" {
  cluster_id           = "elasticache-checkout-retail-store"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.elasticache_sg.id]
  engine_version       = "7.1"
  parameter_group_name = "default.redis7"

}


