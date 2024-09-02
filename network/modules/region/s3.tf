resource "aws_s3_bucket" "network_outputs" {
  bucket = "supergoon-network-outputs-${var.account_config.account}"
  tags   = local.tags
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.network_outputs.bucket
  key    = "network/outputs.json"
  content = jsonencode({
    "vpc" = aws_vpc.vpc
    "subnets" = {
      "public"  = aws_subnet.public,
      "private" = aws_subnet.private
    }
  })

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  # etag = filemd5("path/to/file")
}
