data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  lambda_function_name = var.name

  lambda_vpc_enabled = (
    length(var.lambda_subnet_ids) > 0 &&
    length(var.lambda_security_group_ids) > 0
  )

  base_labels = join(",", [
    "environment", var.environment,
    "cluster", var.cluster_name,
    "aws_account", var.aws_account_id
  ])

  effective_extra_labels = (
    var.extra_labels != ""
    ? "${local.base_labels},${var.extra_labels}"
    : local.base_labels
  )
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_logs" {
  statement {
    sid = "LambdaOwnLogs"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.lambda_function_name}:*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_logs" {
  name   = "${var.name}-lambda-logs"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_logs.json
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_execution" {
  count = local.lambda_vpc_enabled ? 1 : 0

  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}