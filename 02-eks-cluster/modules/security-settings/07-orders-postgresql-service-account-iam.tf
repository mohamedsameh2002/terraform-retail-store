resource "aws_iam_role" "orders_db_secrets_role" {
  name = "orders-db-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = var.tags
}





resource "aws_iam_policy" "orders_db_secret_policy" {
  name        = "orders-db-secret-policy"
  description = "Allow pods to read orders DB secret from AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:${var.aws_region}:${var.account_id}:secret:catalog-db-secret*"
      }
    ]
  })
}


resource "aws_iam_policy" "orders_sqs_policy" {
  name        = "orders-sqs-policy"
  description = "Allow Orders microservice to interact with Amazon SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "OrdersSQSAccess"
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ListQueues",
          "sqs:PurgeQueue"
        ]
        Resource = "arn:aws:sqs:${var.aws_region}:${var.account_id}:orders-queue"
      }
    ]
  })
}




resource "aws_iam_role_policy_attachment" "orders_db_secret_policy_attachment" {
  role       = aws_iam_role.orders_db_secrets_role.name
  policy_arn = aws_iam_policy.orders_db_secret_policy.arn
}

resource "aws_iam_role_policy_attachment" "orders_sqs_policy_attach" {
  depends_on = [aws_iam_policy.orders_sqs_policy]
  role       = aws_iam_role.orders_db_secrets_role.name
  policy_arn = aws_iam_policy.orders_sqs_policy.arn
}





resource "aws_eks_pod_identity_association" "orders_db_role_association" {
  cluster_name    = var.cluster_name
  namespace       = "default"
  service_account = "orders-postgresql"
  role_arn        = aws_iam_role.orders_db_secrets_role.arn
}


