resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-loadbalancer-controller"
  namespace  = "kube-system" 
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.7.2"

  set = [
    {
      name  = "clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "serviceAccount.create"
      value = "false"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "region"
      value = var.region
    },
    {
      name  = "vpcId"
      value = module.vpc.vpc_id
    }
  ]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd" 
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.3.6"

  values = [
    file("${path.module}/values/argocd-values.yaml")
  ]
}