
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "private" {
  bucket = "supergoon-private-${random_string.random.result}"

  tags = {
    Name = "Private Bucket"
  }
}

resource "aws_s3_bucket" "public" {
  bucket = "supergoon-public-${random_string.random.result}"

  tags = {
    Name = "Public Bucket"
  }
}
