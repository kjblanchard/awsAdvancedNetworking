resource "aws_s3_bucket" "flow_log_bucket" {
  bucket = "supergoon-flow-logs-${var.account_config.account}"
  tags   = local.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "flow_log_lifecycle_config" {
  bucket = aws_s3_bucket.flow_log_bucket.id
  rule {
    id = "Clean Up logs daily"
    expiration {
      days = 1
    }
    status = "Enabled"

  }
}

resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_s3_bucket.flow_log_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id
}
