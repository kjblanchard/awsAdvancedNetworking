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
