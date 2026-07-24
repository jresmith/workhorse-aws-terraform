# tflint-ignore: terraform_unused_declarations
locals {
  lambda_promtail_relabel_configs = jsonencode([
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
  ])
}