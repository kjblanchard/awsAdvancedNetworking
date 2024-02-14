resource "aws_nat_gateway" "gw" {
  for_each      = local.nat_subnets
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "NAT Gateway-SG"
  }
}

resource "aws_eip" "nat_eip" {
  for_each = local.nat_subnets
#   instance = aws_instance.web.id
#   domain   = "vpc"
}
