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

cluster_name    = "workhorse-staging-eks"
kubernetes_version = "1.30"

node_group_instance_types = ["t3.large"]
desired_size              = 2
max_size                  = 3
min_size                  = 1

# General Variables
tags = {
  Environment = "staging"
  ManagedBy   = "terraform"
}