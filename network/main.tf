locals {
  config = lookup(var.account_config, terraform.workspace)
  east_1_networks = { for network in local.config.networks : replace(replace(replace("${network.region}_${network.cidr}", "-", "_"), "/", "_"), ".", "_")
  => network if network.region == "us-east-1" }
  east_2_networks = { for network in local.config.networks : replace(replace(replace("${network.region}_${network.cidr}", "-", "_"), "/", "_"), ".", "_")
  => network if network.region == "us-east-2" }
}

module "regional_east1" {
  source         = "./modules/region"
  for_each       = local.east_1_networks
  network        = each.value
  account_config = local.config
  providers = {
    aws = aws.east1
  }
}

module "regional_east2" {
  source         = "./modules/region"
  for_each       = local.east_2_networks
  network        = each.value
  account_config = local.config
  providers = {
    aws = aws.east2
  }
}
