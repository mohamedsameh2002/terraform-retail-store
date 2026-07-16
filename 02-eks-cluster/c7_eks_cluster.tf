resource "aws_eks_cluster" "main" {
  name = local.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.cluster_version
  

  access_config {
     authentication_mode = "API_AND_CONFIG_MAP" #  CONFIG_MAP, API, API_AND_CONFIG_MAP
    bootstrap_cluster_creator_admin_permissions = true
  }


  vpc_config {
    subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    public_access_cidrs =  var.cluster_endpoint_public_access_cidrs
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access = var.cluster_endpoint_public_access
  }
  enabled_cluster_log_types = [
    "api",                 # API server audit logs
    "audit",               # Kubernetes audit logs
    "authenticator",       # Authenticator logs for IAM auth
    "controllerManager",   # Logs for controller manager
    "scheduler"            # Logs for pod scheduling
  ]
   kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  
   depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller
  ]


  tags = var.tags
  

}

