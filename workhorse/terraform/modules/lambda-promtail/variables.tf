variable "name" {
  description = "Name prefix for Lambda Promtail resources."
  type        = string
}

variable "environment" {
  description = "Environment label, for example staging."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name label."
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID used as a Loki label."
  type        = string
}

variable "lambda_image_uri" {
  description = "Full ECR image URI for lambda-promtail."
  type        = string
}

variable "loki_write_address" {
  description = "Loki push API endpoint, for example https://loki.example.com/loki/api/v1/push."
  type        = string
}

variable "loki_username" {
  description = "Optional Loki basic auth username."
  type        = string
  default     = null
  sensitive   = true
}

variable "loki_password" {
  description = "Optional Loki basic auth password."
  type        = string
  default     = null
  sensitive   = true
}

variable "bearer_token" {
  description = "Optional Loki bearer token."
  type        = string
  default     = null
  sensitive   = true
}

variable "tenant_id" {
  description = "Optional Loki tenant ID."
  type        = string
  default     = null
}

variable "skip_tls_verify" {
  description = "Whether Lambda Promtail should skip TLS verification."
  type        = bool
  default     = false
}

variable "keep_stream" {
  description = "Whether to keep the CloudWatch log stream label. Usually false to avoid high cardinality."
  type        = bool
  default     = false
}

variable "batch_size" {
  description = "Lambda Promtail batch size in bytes."
  type        = number
  default     = 131072
}

variable "log_group_names" {
  description = "Existing CloudWatch log groups to subscribe to Lambda Promtail. Use this for EKS and CloudTrail log groups."
  type        = set(string)
  default     = []
}

variable "extra_labels" {
  description = "Extra labels passed to Lambda Promtail as comma-separated key,value pairs."
  type        = string
  default     = ""
}

variable "drop_labels" {
  description = "Comma-separated labels to drop before sending to Loki."
  type        = string
  default     = ""
}

variable "relabel_configs" {
  type = list(object({
    source_labels = list(string)
    regex         = string
    target_label  = string
    replacement   = string
  }))
}

variable "lambda_memory_size" {
  description = "Lambda memory size in MB."
  type        = number
  default     = 256
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 60
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrency for Lambda. Use -1 for unreserved."
  type        = number
  default     = -1
}

variable "lambda_subnet_ids" {
  description = "Optional subnet IDs if Lambda must run inside your VPC to reach Loki."
  type        = list(string)
  default     = []
}

variable "lambda_security_group_ids" {
  description = "Optional security group IDs if Lambda must run inside your VPC to reach Loki."
  type        = list(string)
  default     = []
}

variable "create_lambda_log_group" {
  description = "Whether Terraform should create the Lambda function log group."
  type        = bool
  default     = true
}

variable "lambda_log_retention_days" {
  description = "Retention for Lambda Promtail function logs."
  type        = number
  default     = 14
}

variable "enable_vpc_flow_logs" {
  description = "Create VPC Flow Logs to CloudWatch and subscribe them to Lambda Promtail."
  type        = bool
  default     = false
}

variable "vpc_ids_for_flow_logs" {
  description = "VPC IDs for VPC Flow Logs."
  type        = set(string)
  default     = []
}

variable "vpc_flow_log_retention_days" {
  description = "Retention for VPC Flow Log CloudWatch log groups."
  type        = number
  default     = 14
}

variable "vpc_flow_log_traffic_type" {
  description = "Traffic type for VPC Flow Logs. Valid values are ACCEPT, REJECT, or ALL."
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.vpc_flow_log_traffic_type)
    error_message = "vpc_flow_log_traffic_type must be one of ACCEPT, REJECT, or ALL."
  }
}

variable "enable_route53_resolver_logs" {
  description = "Create Route53 Resolver Query Logs to CloudWatch and subscribe them to Lambda Promtail."
  type        = bool
  default     = false
}

variable "vpc_ids_for_route53_resolver_logs" {
  description = "VPC IDs to associate with Route53 Resolver query logging."
  type        = set(string)
  default     = []
}

variable "route53_resolver_log_retention_days" {
  description = "Retention for Route53 Resolver log group."
  type        = number
  default     = 14
}