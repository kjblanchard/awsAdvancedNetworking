resource "aws_vpc" "vpc" {
  cidr_block                       = var.network.cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true
  tags = merge(local.tags, {
    Name : title("Supergoon-${var.account_config.name}-${var.account_config.environment}")
  })
}
