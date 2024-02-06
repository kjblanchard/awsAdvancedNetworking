variable "provider_tags" {
  description = "Tags that are applied to the aws provider"
  type        = map(string)
}

variable "account_config" {
  description = "The networks that we are going to create for ALL workspaces."
  type = map(object({
    name        = string
    environment = string
    networks = list(object({
      cidr        = string
      region      = string
      subnets     = list(string)
      subnet_size = number
      azs         = number
    }))
  }))
}
