# Outputs
output "checkout_redis_endpoint" {
  value = aws_elasticache_cluster.checkout_elasticache.cache_nodes[0].address
}
