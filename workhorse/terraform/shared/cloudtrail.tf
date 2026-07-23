# Staging Cloudwatch Config
resource "aws_cloudwatch_log_group" "cloudtrail_staging" {
  name              = "/aws/cloudtrail/workhorse-staging"
  retention_in_days = 30
}

# CloudTrail logs are encrypted via S3 SSE-AES256.
#tfsec:ignore:aws-cloudtrail-enable-at-rest-encryption
resource "aws_cloudtrail" "main_staging" {
  name = "workhorse-staging"

  s3_bucket_name = aws_s3_bucket.cloudtrail_staging.id

  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_staging.arn}:*"

  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail_cloudwatch.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  depends_on = [
    aws_s3_bucket_policy.cloudtrail_staging,
    aws_iam_role_policy.cloudtrail_cloudwatch_staging
  ]
}

# Production Cloudwatch Config
resource "aws_cloudwatch_log_group" "cloudtrail_prod" {
  name              = "/aws/cloudtrail/workhorse-prod"
  retention_in_days = 30
}

# CloudTrail logs are encrypted via S3 SSE-AES256.
#tfsec:ignore:aws-cloudtrail-enable-at-rest-encryption
resource "aws_cloudtrail" "main_prod" {
  name = "workhorse-prod"

  s3_bucket_name = aws_s3_bucket.cloudtrail_prod.id

  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_prod.arn}:*"

  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail_cloudwatch.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  depends_on = [
    aws_s3_bucket_policy.cloudtrail_prod,
    aws_iam_role_policy.cloudtrail_cloudwatch_prod
  ]
}