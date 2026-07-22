# General Variables
variable "region" {
  type    = string
  default = "us-west-2"
}

variable "tags" {
  type        = map(string)
  description = "Tags for Staging environment workoad"
}

# VPC Variables
variable "vpc_name" {
  type        = string
  description = "Name of the VPC used in the Staging enivironment"
}

variable "vpc_cidr" {
  type        = string
  description = "Entire staging environment cidr"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Subnets to be used for Public ranges in staging env - to be used across multiple AZs"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Subnets to be used for Private ranges in staging env - to be used across multiple AZs"
}

variable "azs" {
  type        = list(string)
  description = "List of AZs to be used within staging env"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Boolean to enable NAT gateway in VPC"
}

variable "single_nat_gateway" {
  type        = bool
  description = "Boolean to have a single NAT gateway in VPC"
}

# EKS Variables
variable "cluster_name" {
  type        = string
  description = "Name of K8s to be used in EKS"
}

variable "kubernetes_version" {
  type        = string
  description = "K8s version to be used in EKS"
}

variable "node_group_instance_types" {
  type        = list(string)
  description = "Instance type of K8s nodes"
}
variable "desired_size" {
  type        = number
  description = "Desired Number of K8s nodes."
}

variable "max_size" {
  type        = number
  description = "Maximum Number of K8s nodes"
}

variable "min_size" {
  type        = number
  description = "Minimum Number of K8s nodes"
}

# Promtail Variables
variable "lambda_promtail_image_uri" {
  description = "Full ECR image URI for Lambda Promtail."
  type        = string
}

variable "relabel_configs" {
  type = list(object({
    source_labels = list(string)
    regex         = string
    target_label  = string
    replacement   = string
  }))
}

variable "loki_write_address" {
  description = "Loki push endpoint."
  type        = string
}

variable "loki_username" {
  description = "Loki basic auth username."
  type        = string
  sensitive   = true
  default     = null
}

variable "loki_password" {
  description = "Loki basic auth password."
  type        = string
  sensitive   = true
  default     = null
}

variable "loki_bearer_token" {
  description = "Optional Loki bearer token."
  type        = string
  sensitive   = true
  default     = null
}
