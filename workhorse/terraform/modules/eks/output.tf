output "cluster_name" {
  description = "Name of the EKS Cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "API Server Endpoint for the EKS Cluster"
  value       = module.eks.cluster_endpoint
}

output "cluster_ca_data" {
  description = "Base64-encoded CA data required for authing in kubectl and other clents to EKS API Server"
  value       = module.eks.cluster_certificate_authority_data
}

output "node_groups" {
  description = "Details of Managed node group."
  value       = module.eks.eks_managed_node_groups
}

output "oidc_provider" {
  description = "OIDC provider within the cluster"
  value       = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider within the cluster"
  value       = module.eks.oidc_provider_arn
}