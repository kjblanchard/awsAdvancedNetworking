resource "aws_key_pair" "ec2" {
  key_name   = "kjb-ec2-key"
  public_key = file("/Users/kevin/.ssh/id_rsa_ec2.pub")
}

