locals {
  vpc_flow_log_group_names = var.enable_vpc_flow_logs ? {
    for vpc_id in var.vpc_ids_for_flow_logs :
    vpc_id => "/aws/vpc-flow-logs/${var.environment}/${vpc_id}"
  } : {}

  route53_log_group_name = "/aws/route53-resolver/${var.environment}/${var.cluster_name}"

  route53_log_group_names = var.enable_route53_resolver_logs ? toset([
    local.route53_log_group_name
  ]) : toset([])

  managed_log_group_names = setunion(
    toset(values(local.vpc_flow_log_group_names)),
    local.route53_log_group_names
  )

  all_subscription_log_group_names = setunion(
    var.log_group_names,
    local.managed_log_group_names
  )
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  for_each = local.all_subscription_log_group_names

  statement_id   = "AllowExecutionFromCloudWatch-${substr(md5(each.value), 0, 12)}"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.this.function_name
  principal      = "logs.${data.aws_region.current.name}.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id

  source_arn = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${each.value}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "this" {
  for_each = local.all_subscription_log_group_names

  name            = "${var.name}-${substr(md5(each.value), 0, 12)}"
  log_group_name  = each.value
  filter_pattern  = ""
  destination_arn = aws_lambda_function.this.arn

  depends_on = [
    aws_lambda_permission.allow_cloudwatch,
    aws_cloudwatch_log_group.vpc_flow,
    aws_cloudwatch_log_group.route53_resolver
  ]
}

resource "aws_cloudwatch_log_group" "vpc_flow" {
  for_each = local.vpc_flow_log_group_names

  name              = each.value
  retention_in_days = var.vpc_flow_log_retention_days
}

data "aws_iam_policy_document" "vpc_flow_logs_assume_role" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "vpc-flow-logs.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "vpc_flow_logs" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  name               = "${var.name}-vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_assume_role[0].json
}

data "aws_iam_policy_document" "vpc_flow_logs" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]

    resources = [
      for log_group in aws_cloudwatch_log_group.vpc_flow :
      "${log_group.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "vpc_flow_logs" {
  count = var.enable_vpc_flow_logs ? 1 : 0

  name   = "${var.name}-vpc-flow-logs"
  role   = aws_iam_role.vpc_flow_logs[0].id
  policy = data.aws_iam_policy_document.vpc_flow_logs[0].json
}

resource "aws_flow_log" "vpc" {
  for_each = var.enable_vpc_flow_logs ? var.vpc_ids_for_flow_logs : toset([])

  iam_role_arn    = aws_iam_role.vpc_flow_logs[0].arn
  log_destination = aws_cloudwatch_log_group.vpc_flow[each.value].arn
  traffic_type    = var.vpc_flow_log_traffic_type
  vpc_id          = each.value

  depends_on = [
    aws_iam_role_policy.vpc_flow_logs
  ]
}

resource "aws_cloudwatch_log_group" "route53_resolver" {
  count = var.enable_route53_resolver_logs ? 1 : 0

  name              = local.route53_log_group_name
  retention_in_days = var.route53_resolver_log_retention_days
}

data "aws_iam_policy_document" "route53_resolver_cloudwatch" {
  count = var.enable_route53_resolver_logs ? 1 : 0

  statement {
    sid = "Route53ResolverQueryLogsToCloudWatch"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.route53_resolver[0].arn}:*"
    ]

    principals {
      type = "Service"

      identifiers = [
        "route53resolver.amazonaws.com"
      ]
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "route53_resolver" {
  count = var.enable_route53_resolver_logs ? 1 : 0

  policy_name     = "${var.name}-route53-resolver"
  policy_document = data.aws_iam_policy_document.route53_resolver_cloudwatch[0].json
}

resource "aws_route53_resolver_query_log_config" "this" {
  count = var.enable_route53_resolver_logs ? 1 : 0

  name            = "${var.name}-route53-resolver"
  destination_arn = aws_cloudwatch_log_group.route53_resolver[0].arn

  depends_on = [
    aws_cloudwatch_log_resource_policy.route53_resolver
  ]
}

resource "aws_route53_resolver_query_log_config_association" "this" {
  for_each = var.enable_route53_resolver_logs ? var.vpc_ids_for_route53_resolver_logs : toset([])

  resolver_query_log_config_id = aws_route53_resolver_query_log_config.this[0].id
  resource_id                  = each.value
}