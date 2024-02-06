data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs       = slice([for az in data.aws_availability_zones.available.names : az], 0, var.network.azs)
  num_cidrs = length(var.network.subnets) * var.network.azs
  subnets = flatten([
    for i in range(length(var.network.subnets)) : [
      for j in range(length(local.azs)) : {
        name = replace("${var.network.subnets[i]}_${local.azs[j]}", "-", "_")
        cidr = cidrsubnet(var.network.cidr, var.network.subnet_size, i * length(local.azs) + j)
        az = local.azs[j]
      }
    ]
  ])
  tags = {
    Region : var.network.region
    Environment : var.account_config.environment
  }
}

