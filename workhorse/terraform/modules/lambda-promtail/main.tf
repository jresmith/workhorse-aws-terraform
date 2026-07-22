resource "aws_cloudwatch_log_group" "lambda" {
  count = var.create_lambda_log_group ? 1 : 0

  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = var.lambda_log_retention_days
}

resource "aws_lambda_function" "this" {
  function_name = local.lambda_function_name
  role          = aws_iam_role.lambda.arn

  package_type  = "Image"
  image_uri     = var.lambda_image_uri
  architectures = ["x86_64"]

  memory_size                    = var.lambda_memory_size
  timeout                        = var.lambda_timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions

  dynamic "vpc_config" {
    for_each = local.lambda_vpc_enabled ? [1] : []

    content {
      subnet_ids         = var.lambda_subnet_ids
      security_group_ids = var.lambda_security_group_ids
    }
  }

  environment {
    variables = {
      WRITE_ADDRESS   = var.loki_write_address
      USERNAME        = var.loki_username != null ? var.loki_username : ""
      PASSWORD        = var.loki_password != null ? var.loki_password : ""
      BEARER_TOKEN    = var.bearer_token != null ? var.bearer_token : ""
      TENANT_ID       = var.tenant_id != null ? var.tenant_id : ""
      SKIP_TLS_VERIFY = tostring(var.skip_tls_verify)
      KEEP_STREAM     = tostring(var.keep_stream)
      BATCH_SIZE      = tostring(var.batch_size)
      EXTRA_LABELS    = local.effective_extra_labels
      DROP_LABELS     = var.drop_labels
      RELABEL_CONFIGS = jsonencode(var.relabel_configs)
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda_logs
  ]
} 