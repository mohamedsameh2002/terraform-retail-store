resource "aws_iam_role" "catalog_db_secrets_role" {
  name = "catalog-db-secrets-role"

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





resource "aws_iam_policy" "catalog_db_secret_policy" {
  name        = "catalog-db-secret-policy"
  description = "Allow pods to read Catalog DB secret from AWS Secrets Manager"

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

resource "aws_iam_role_policy_attachment" "catalog_db_secret_policy_attachment" {
  role       = aws_iam_role.catalog_db_secrets_role.name
  policy_arn = aws_iam_policy.catalog_db_secret_policy.arn
}



resource "aws_eks_pod_identity_association" "catalog_db" {
  cluster_name    = var.cluster_name
  namespace       = "default"
  service_account = "catalog-mysql-sa"
  role_arn        = aws_iam_role.catalog_db_secrets_role.arn
}