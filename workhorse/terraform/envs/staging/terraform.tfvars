# VPC Variables
region = "us-west-2"

vpc_name = "workhorse-staging-vpc"

vpc_cidr = "10.99.0.0/16"

public_subnet_cidrs = [
  "10.99.0.0/24",
  "10.99.1.0/24",
  "10.99.2.0/24"
]

private_subnet_cidrs = [
  "10.99.32.0/19",
  "10.99.64.0/19",
  "10.99.96.0/19"
]

azs = [
  "us-west-2a",
  "us-west-2b",
  "us-west-2c"
]

enable_nat_gateway = true
single_nat_gateway = true

# EKS Variables
cluster_name       = "workhorse-staging-eks"
kubernetes_version = "1.34"

node_group_instance_types = ["t3.large"]
desired_size              = 2
max_size                  = 3
min_size                  = 1

# Promtail Variables

lambda_promtail_image_uri = "945503455271.dkr.ecr.us-west-2.amazonaws.com/lambda-promtail:v2"
loki_write_address        = "https://loki.staging.jresmith.com/loki/api/v1/push"

relabel_configs = [
  {
    source_labels = ["__aws_cloudwatch_log_group"]
    regex         = "/aws/cloudtrail/.*"
    target_label  = "source"
    replacement   = "cloudtrail"
  },
  {
    source_labels = ["__aws_cloudwatch_log_group"]
    regex         = "/aws/vpc-flow-logs/.*"
    target_label  = "source"
    replacement   = "vpcflow"
  },
  {
    source_labels = ["__aws_cloudwatch_log_group"]
    regex         = "/aws/route53-resolver/.*"
    target_label  = "source"
    replacement   = "route53"
  },
  {
    source_labels = ["__aws_cloudwatch_log_group"]
    regex         = "/aws/eks/.*/cluster"
    target_label  = "source"
    replacement   = "eks-control-plane"
  }
]

# General Variables
tags = {
  Environment = "staging"
  ManagedBy   = "terraform"
}