resource "aws_organizations_organization" "organization" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com"
  ]

  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "root_organizational_units" {
  for_each  = local.root_ous
  name      = each.value.name
  parent_id = aws_organizations_organization.organization.roots[0].id
}

resource "aws_organizations_organizational_unit" "level_1_organizational_units" {
  for_each  = local.level_1_ous
  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.root_organizational_units[each.value.parent].id
}

resource "aws_organizations_organizational_unit" "level_2_organizational_units" {
  for_each  = local.level_2_ous
  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.level_1_organizational_units[each.value.parent].id
}

resource "aws_organizations_organizational_unit" "level_3_organizational_units" {
  for_each  = local.level_3_ous
  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.level_2_organizational_units[each.value.parent].id
}

resource "aws_organizations_account" "account" {
  for_each          = local.all_accounts
  name              = title(format("%s-%s-%s", "Supergoon", each.value.environment, each.value.name))
  email             = "${var.personal_email}+${each.value.email}@gmail.com"
  parent_id         = local.all_ou_resources[each.value.parent].id
  close_on_deletion = true
  role_name         = "OrganizationAccountAccessRole"
}



