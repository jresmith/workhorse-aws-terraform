output "lambda_function_name" {
  description = "Lambda Promtail function name."
  value       = aws_lambda_function.this.function_name
}

output "lambda_function_arn" {
  description = "Lambda Promtail function ARN."
  value       = aws_lambda_function.this.arn
}

output "subscribed_log_groups" {
  description = "CloudWatch log groups subscribed to Lambda Promtail."
  value       = local.all_subscription_log_group_names
}

output "vpc_flow_log_groups" {
  description = "VPC Flow Log CloudWatch log groups created by this module."
  value       = local.vpc_flow_log_group_names
}

output "route53_resolver_log_group_name" {
  description = "Route53 Resolver Query Log CloudWatch log group."
  value       = var.enable_route53_resolver_logs ? local.route53_log_group_name : null
}