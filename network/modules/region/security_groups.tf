data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}
locals {
  security_group_ids = {
    pingbot = aws_security_group.pingbot.id
    bastion = aws_security_group.bastion.id
  }
}

resource "aws_security_group" "pingbot" {
  name        = "Allow pinbbot outbound"
  description = "Allow pingbot ssh traffic from other pingbots and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "Allow Pingbot"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id            = aws_security_group.pingbot.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
  referenced_security_group_id = aws_security_group.pingbot.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.pingbot.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_security_group" "bastion" {
  name        = "Allow SSH inbound"
  description = "Allow  ssh traffic from public IPs"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "Allow SSH From Home"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_bastion" {
  security_group_id = aws_security_group.bastion.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  cidr_ipv4         = "${chomp(data.http.myip.response_body)}/32"
}

resource "aws_vpc_security_group_egress_rule" "bastion_outbound" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}
