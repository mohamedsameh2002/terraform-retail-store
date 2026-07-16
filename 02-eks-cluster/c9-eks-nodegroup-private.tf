resource "aws_eks_node_group" "private_nodes" {
  cluster_name = aws_eks_cluster.main.name

  node_group_name = "${local.name}-private-ng"
  node_role_arn = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  instance_types = var.node_instance_types 
  capacity_type = var.node_capacity_type
  ami_type = "AL2023_x86_64_STANDARD"
  disk_size = var.node_disk_size

  scaling_config {
    # Desired number of nodes when the node group is created
    desired_size = 2

    # Minimum number of nodes allowed
    min_size = 1

    # Maximum number of nodes the group can scale to
    max_size = 3
  }

   update_config {
    max_unavailable_percentage = 33
  }

   force_update_version = true

  # Apply labels to each EC2 instance for easier scheduling and management in Kubernetes
  labels = {
    "env"  = var.environment_name
    "team" = var.business_division
  }


     tags = merge(var.tags, {
    # Standard EC2 name tag
    Name = "${local.name}-private-ng"

    # Logical environment (e.g., dev, prod)
    Environment = var.environment_name
  })

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy
  ]
}