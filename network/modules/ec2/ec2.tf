data "aws_ami" "amazon3" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] #aws
}

resource "aws_instance" "ec2" {
  ami                  = data.aws_ami.amazon3.id
  instance_type        = "t3.micro"
  subnet_id            = var.subnet_id
  iam_instance_profile = var.instance_profile_name == "" ? null : var.instance_profile_name
  key_name = var.key_pair == "" ? null : var.key_pair

  tags = {
    Name = "Ec2-${var.name}"
  }
}
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  count                = var.security_group_id == "" ? 0 : 1
  security_group_id    = var.security_group_id
  network_interface_id = aws_instance.ec2.primary_network_interface_id
}



