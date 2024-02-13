resource "aws_network_acl" "vpc_nacl" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.tags, {
    Name : "vpc_nacl"
  })
}
resource "aws_network_acl_rule" "default_allow_outbound" {
  network_acl_id = aws_network_acl.vpc_nacl.id
  rule_number    = 200
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "default_allow_inbound" {
  network_acl_id = aws_network_acl.vpc_nacl.id
  rule_number    = 201
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl" "default_blackhole" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.tags, {
    Name : "blackhole"
  })
}
