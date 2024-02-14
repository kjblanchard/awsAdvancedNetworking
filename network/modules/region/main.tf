data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs       = slice([for az in data.aws_availability_zones.available.names : az], 0, var.network.azs)
  num_cidrs = length(var.network.subnets) * var.network.azs
  subnets = flatten([
    for i in range(length(var.network.subnets)) : [
      for j in range(length(local.azs)) : {
        name    = replace("${var.network.subnets[i].name}_${local.azs[j]}", "-", "_")
        cidr    = cidrsubnet(var.network.cidr, var.network.subnet_size, i * length(local.azs) + j)
        az      = local.azs[j]
        public  = try(var.network.subnets[i].public, false)
        bastion = try(var.network.subnets[i].bastion, false)
      }
    ]
  ])
  private_subnets = [for subnet in local.subnets : subnet if !subnet.public]
  public_subnets  = [for subnet in local.subnets : subnet if subnet.public]
  bastion_subnets = [for subnet in local.public_subnets : subnet if subnet.bastion]
  # bastion_subnets_each = {for subnet in local.bastion_subnets: subnet.name => subnet}
  tags = {
    Region : var.network.region
    Environment : var.account_config.environment
  }
  public_route_table_routes = {
    main = {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }
    main_v6 = {
      ipv6_cidr_block        = "::/0"
      egress_only_gateway_id = aws_egress_only_internet_gateway.gwv6.id

    }
  }
  private_route_table_routes = {}
}

