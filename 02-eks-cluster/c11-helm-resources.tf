resource "helm_release" "secrets_store_csi_driver" {

  name       = "csi-secrets-store"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"

  # Note: tokenRequests is required for EKS Pod Identity authentication when
  # the CSI driver is installed separately (not bundled via the AWS provider chart).
  # Audience "pods.eks.amazonaws.com" is for EKS Pod Identity. We do not configure
  # the IRSA audience (sts.amazonaws.com) because this course uses Pod Identity only.
  set = [
    {
      name  = "syncSecret.enabled"
      value = "true"
    },
    {
      name  = "tokenRequests[0].audience"
      value = "pods.eks.amazonaws.com"
    },
  ]

  # Wait until all pods are ready
  wait            = true
  timeout         = 600
  cleanup_on_fail = true
}








resource "helm_release" "aws_provider_ascp" {
  name       = "secrets-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"

  create_namespace = false

  set = [ {
     name  = "secrets-store-csi-driver.install"
    value = "false"
  } ]

  depends_on = [
    helm_release.secrets_store_csi_driver
  ]
}




resource "helm_release" "lb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  create_namespace = false

  set = [
  {
    name  = "clusterName"
    value = local.eks_cluster_name
  },
  {
    name  = "region"
    value = var.aws_region
  },
  {
    name  = "vpcId"
    value = data.terraform_remote_state.vpc.outputs.vpc_id
  },
  {
    name  = "serviceAccount.create"
    value = "true"
  },
  {
    name  = "serviceAccount.name"
    value = "load-balancer-controller"
  }
]
depends_on = [ 
  module.security-settings
 ]

}
