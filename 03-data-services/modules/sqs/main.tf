resource "aws_sqs_queue" "orders_sqs_queue" {
  name                        = "orders-queue"
  message_retention_seconds   = 86400     # 1 day
  visibility_timeout_seconds  = 30
  delay_seconds               = 0
  receive_wait_time_seconds   = 10

  tags = {
    Name        = "orders-queue"
    Component   = "Orders"
    Environment = var.environment_name
  }
}