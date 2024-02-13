
resource "aws_iam_instance_profile" "ssm_profile" {
  name     = "ssm_profile"
  role     = aws_iam_role.ssm_ec2_role.name
  provider = aws.east1
}

resource "aws_iam_role" "ssm_ec2_role" {
  name = "SSM-EC2-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  provider = aws.east1
  tags = {
    tag-key = "tag-value"
  }
}
