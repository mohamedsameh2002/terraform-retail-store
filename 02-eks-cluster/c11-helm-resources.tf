
resource "helm_release" "secrets_store_csi_driver" {
  name       = "csi-secrets-store"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"
  set = [ {
    name  = "tokenRequests[0].audience"
    value = "pods.eks.amazonaws.com"
  } ]

  create_namespace = false
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
    value = var.cluster_name
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
    value = "aws-load-balancer-controller"
  }
]

}
