# ------------------------------------------------------------------------------
# IAM Role for EKS Control Plane
# This role is assumed by the EKS service to manage the control plane resources
# ------------------------------------------------------------------------------
resource "aws_iam_role" "eks_cluster" {
  # Unique name for the control plane IAM role
  name = "${local.name}-eks-cluster-role"

  # Trust policy to allow EKS to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  # Tags applied to this IAM role
  tags = var.tags
}

# ------------------------------------------------------------------------------
# Attach the required policy for EKS to manage cluster control plane
# This is mandatory for all EKS clusters
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ------------------------------------------------------------------------------
# Attach VPC Resource Controller policy
# Required for advanced networking, Fargate, and Karpenter support
# Recommended to include by default for production-grade EKS
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}




# resource "aws_iam_policy" "ec2_start_stop" {
#   name = "EC2StartStop"

#   policy = jsonencode({
#     Version = "2012-10-17"

#     Statement = [{
#       Effect = "Allow"

#       Action = [
#         "ec2:StartInstances",
#         "ec2:StopInstances"
#       ]

#       Resource = "*"
#     }]
#   })
# }


# resource "aws_iam_role_policy_attachment" "attach" {
#   role       = aws_iam_role.eks_cluster.name
#   policy_arn = aws_iam_policy.ec2_start_stop.arn
# }