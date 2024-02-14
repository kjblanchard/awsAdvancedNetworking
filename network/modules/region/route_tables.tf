resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = local.public_route_table_routes
    content {
      cidr_block             = try(route.value.cidr_block, null)
      gateway_id             = try(route.value.gateway_id, null)
      ipv6_cidr_block        = try(route.value.ipv6_cidr_block, null)
      egress_only_gateway_id = try(route.value.egress_only_gateway_id, null)
    }
  }

  tags = {
    Name = "Public"
  }
}

resource "aws_route_table" "private" {
  for_each = { for subnet in local.private_subnets : subnet.name => subnet }
  vpc_id   = aws_vpc.vpc.id

  dynamic "route" {
    for_each = local.private_route_table_routes
    content {
      cidr_block             = try(route.value.cidr_block, null)
      gateway_id             = try(route.value.gateway_id, null)
      ipv6_cidr_block        = try(route.value.ipv6_cidr_block, null)
      egress_only_gateway_id = try(route.value.egress_only_gateway_id, null)
    }
  }
  dynamic "route" {
    for_each = each.value.nat ? [0] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.gw[each.value.nat_subnet].id
    }
  }

  tags = {
    Name = "Private-${each.key}"
  }
}
