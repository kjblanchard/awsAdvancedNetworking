resource "aws_subnet" "private" {
  for_each          = { for subnet in local.private_subnets : subnet.name => subnet }
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  tags = merge(local.tags, {
    Name : each.value.name
  })
}

resource "aws_subnet" "public" {
  for_each          = { for subnet in local.public_subnets : subnet.name => subnet }
  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  map_public_ip_on_launch = true
  tags = merge(local.tags, {
    Name : each.value.name
  })
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id

}

resource "aws_network_acl_association" "private" {
  for_each       = aws_subnet.private
  network_acl_id = aws_network_acl.vpc_nacl.id
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id

}

resource "aws_network_acl_association" "public" {
  for_each       = aws_subnet.public
  network_acl_id = aws_network_acl.vpc_nacl.id
  subnet_id      = each.value.id
}
