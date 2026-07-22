resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/workhorse-staging"
  retention_in_days = 30
}

resource "aws_cloudtrail" "main" {
  name = "workhorse-staging"

  s3_bucket_name = aws_s3_bucket.cloudtrail.id

  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"

  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail_cloudwatch.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  depends_on = [
    aws_s3_bucket_policy.cloudtrail,
    aws_iam_role_policy.cloudtrail_cloudwatch
  ]
}