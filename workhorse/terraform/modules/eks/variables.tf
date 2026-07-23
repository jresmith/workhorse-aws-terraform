
variable "cluster_name" {
  type = string
  description = "Name of cluster to be used in EKS"
}

variable "kubernetes_version" {
  type = string
  description = "K8s version to be used in EKS"
}

variable "vpc_id" {
  type = string
  description = "ID of VPC to be used - Generated as part of VPC Module"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "ID of Private Subnet to be used - Generated as part of VPC Module"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "ID of Public Subnet to be used - Generated as part of VPC Module (Optional: used for load balances if needed)"
  default = []
}

# variable "enable_cluster_encryption" {
#   type        = bool
#   description = "Enable cluster encryption (not required in Staging Enivironment)"
#   default     = true
## }

variable "node_group_instance_types" {
  type = list(string)
  description = "Instance type of K8s nodes"
  default = ["t3.large"]
}

variable "endpoint_public_access" {
  type = bool
  description = "Determines whether the EKI API Server is publicly accessible."
  default = true
}

variable "endpoint_private_access" {
  type = bool
  description = "Determines whether the EKI API Server is private accessible."
  default = true
}

variable "enable_cluster_creator_admin_permissions" {
  type = bool
  description = "Grants the cluster creator full admin permissions."
  default = true
}

variable "desired_size" {
  type = number
  description = "Desired Number of K8s nodes"
}

variable "max_size" {
  type = number
  description = "Maximum Number of K8s nodes"
}

variable "min_size" {
  type = number
  description = "Minimum Number of K8s nodes"
}

variable "tags" {
  type = map(string)
  description = "Tags for Staging Environment workoad (EKS Infra)"
  default = {
    ManagedBy = "terraform"
  }
}
