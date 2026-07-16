module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name    = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id             = var.vpc_id
  subnet_ids         = var.private_subnet_ids

  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = var.endpoint_private_access
 
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  addons = {
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }
    kube-proxy = {
      most_recent    = true
      before_compute = true
    }
    coredns = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_group_instance_types

      desired_size   = var.desired_size
      max_size       = var.max_size
      min_size       = var.min_size

      subnet_ids     = var.private_subnet_ids
    }
  }

  tags = var.tags
}