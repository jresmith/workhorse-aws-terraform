resource "aws_iam_role" "cloudtrail_cloudwatch" {
  name = "cloudtrail-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

#tfsec:ignore:aws-iam-no-policy-wildcards
# CloudTrail creates log streams dynamically. 
# AWS requires the log-group ARN wildcard suffix (:*) for logs:CreateLogStream and logs:PutLogEvents.
resource "aws_iam_role_policy" "cloudtrail_cloudwatch_staging" {
  name = "cloudtrail-cloudwatch"
  role = aws_iam_role.cloudtrail_cloudwatch.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "${aws_cloudwatch_log_group.cloudtrail_staging.arn}:*"
      }
    ]
  })
}

#tfsec:ignore:aws-iam-no-policy-wildcards
# CloudTrail creates log streams dynamically.
# AWS requires the log-group ARN wildcard suffix (:*)
# for logs:CreateLogStream and logs:PutLogEvents.
resource "aws_iam_role_policy" "cloudtrail_cloudwatch_prod" {
  name = "cloudtrail-cloudwatch"
  role = aws_iam_role.cloudtrail_cloudwatch.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "${aws_cloudwatch_log_group.cloudtrail_prod.arn}:*"
      }
    ]
  })
}

