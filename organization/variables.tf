variable "provider_tags" {
  description = "Tags that are applied to the aws provider"
  type        = map(string)
}

variable "org_map" {
  description = "An organization for accounts and information about them"
#   type        = map(any)
}

variable "personal_email" {
    description = "Personal email so that we can use the same email for everything"
}
