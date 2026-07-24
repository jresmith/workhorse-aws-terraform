module "vpc" {
  source = "../../modules/vpc"

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  cluster_name = var.cluster_name

  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  tags = var.tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets

  endpoint_public_access  = true
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  node_group_instance_types = var.node_group_instance_types
  desired_size              = var.desired_size
  max_size                  = var.max_size
  min_size                  = var.min_size

  tags = var.tags
}

module "lambda_promtail" {
  source = "../../modules/lambda-promtail"

  name           = "workhorse-staging-lambda-promtail"
  environment    = "staging"
  cluster_name   = var.cluster_name
  aws_account_id = "945503455271"

  lambda_image_uri   = var.lambda_promtail_image_uri
  loki_write_address = var.loki_write_address
  lambda_subnet_ids  = module.vpc.private_subnets
  lambda_security_group_ids = [
    aws_security_group.lambda_promtail.id
  ]

  tenant_id       = null
  skip_tls_verify = false
  keep_stream     = false
  batch_size      = 131072

  extra_labels    = "platform,aws"
  relabel_configs = var.relabel_configs

  log_group_names = toset([
    "/aws/eks/workhorse-staging-eks/cluster",
    "/aws/cloudtrail/workhorse-staging"
  ])

  enable_vpc_flow_logs = true

  vpc_ids_for_flow_logs = {
    main = module.vpc.vpc_id
  }

  vpc_flow_log_traffic_type   = "ALL"
  vpc_flow_log_retention_days = 14

  enable_route53_resolver_logs = true

  vpc_ids_for_route53_resolver_logs = {
    main = module.vpc.vpc_id
  }

  route53_resolver_log_retention_days = 14
}