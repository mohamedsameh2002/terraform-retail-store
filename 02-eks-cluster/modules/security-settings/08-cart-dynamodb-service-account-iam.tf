# IAM Role for Cart microservice (Pod Identity)
resource "aws_iam_role" "cart_dynamodb_role" {
  name = "retail-cart-dynamodb-role"

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

  tags = {
    Name        = "retail-cart-dynamodb-role"
    Environment = var.environment_name
    Component   = "Cart"
  }
}


# IAM Policy for DynamoDB Access (Cart microservice)
resource "aws_iam_policy" "cart_dynamodb_policy" {
  name        = "retail-cart-dynamodb-policy"
  description = "Allow Cart microservice full access to DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:CreateTable",
          "dynamodb:DeleteTable",
          "dynamodb:DescribeTable",
          "dynamodb:UpdateTable",
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:ListTables",
          "dynamodb:ListTagsOfResource"
        ]
        Resource = "*"
      }
    ]
  })
}


# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "cart_dynamodb_policy_attach" {
  role       = aws_iam_role.cart_dynamodb_role.name
  policy_arn = aws_iam_policy.cart_dynamodb_policy.arn
}
resource "aws_eks_pod_identity_association" "cart_dynamodb_policy_attach_role_association" {
  cluster_name    = var.cluster_name
  namespace       = "default"
  service_account = "cart-dynamodb"
  role_arn        = aws_iam_role.cart_dynamodb_role.arn
}