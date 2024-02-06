resource "aws_vpc" "vpc" {
  cidr_block                       = var.network.cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
  tags = merge(local.tags, {
    Name : title("Supergoon-${var.account_config.name}-${var.account_config.environment}")
  })
}

resource "aws_subnet" "main" {
  for_each   = { for subnet in local.subnets : subnet.name => subnet }
  vpc_id     = aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block = each.value.cidr
  map_public_ip_on_launch = true
  tags = merge(local.tags, {
    Name : each.value.name
  })
}
