resource "aws_iam_role" "load_balancer_controller_role" {
  name = "${var.cluster_name}-load-balancer-controller-role"

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

resource "aws_iam_policy" "load_balancer_controller" {
  name        = "${var.cluster_name}-AWSLoadBalancerControllerIAMPolicy"
  description = "IAM Policy for AWS Load Balancer Controller"
  policy = data.http.lb_controller_policy.response_body

}

resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  role       = aws_iam_role.load_balancer_controller_role.name
  policy_arn = aws_iam_policy.load_balancer_controller.arn
}



resource "aws_eks_pod_identity_association" "load_balancer_controller" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "load-balancer-controller"

  role_arn = aws_iam_role.load_balancer_controller_role.arn
}