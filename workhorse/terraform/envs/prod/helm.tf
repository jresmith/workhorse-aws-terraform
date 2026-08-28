resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-loadbalancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.13.0"

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "serviceMonitor.enabled"
    value = "true"
  }

  set {
    name  = "serviceMonitor.namespace"
    value = "monitoring"
  }

  set {
    name  = "serviceMonitor.additionalLabels.release"
    value = "kube-prometheus-stack"
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  wait            = true
  timeout         = 600
  cleanup_on_fail = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "10.1.2"

  values = [
    file("${path.module}/values/argocd-values.yaml")
  ]
}

resource "helm_release" "external_dns" {
  name      = "external-dns"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.21.1"

  wait            = true
  timeout         = 600
  cleanup_on_fail = true

  set {
    name  = "provider.name"
    value = "aws"
  }
  
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  
  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }
  
  set {
    name  = "domainFilters[0]"
    value = "jresmith.com"
  }

  set {
    name  = "excludeDomains[0]"
    value = "staging.jresmith.com"
  }

  set {
    name  = "txtOwnerId"
    value = "workhorse-prod"
  }

  set {
    name  = "policy"
    value = "upsert-only"
  }

  set {
    name  = "extraArgs[0]"
    value = "--zone-id-filter=${data.aws_route53_zone.public.zone_id}"
  }

  set {
    name  = "extraArgs[1]"
    value = "--aws-zone-type=public"
  }

  depends_on = [
    aws_eks_pod_identity_association.external_dns,
    helm_release.aws_load_balancer_controller
  ]
}