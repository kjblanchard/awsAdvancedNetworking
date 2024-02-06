locals {
  root_objects = [for root_ou_name, root_ou_value in var.org_map : {
    name     = root_ou_name
    children = root_ou_value.children
    scps     = root_ou_value.scps
    parent   = "root"
    email    = try(root_ou_value.email, "")
    key      = "root_${root_ou_name}"
  }]
  level_1_objects = flatten([for root_object in local.root_objects :
    [for child_key, child_value in root_object.children :
      {
        name     = child_key
        children = try(child_value.children, {})
        scps     = try(child_value.ous, [])
        parent   = "${root_object.parent}_${root_object.name}"
        email    = try(child_value.email, "")
        key      = "${root_object.parent}_${root_object.name}_${child_key}"
  }]])
  level_2_objects = flatten([for obj in local.level_1_objects :
    [for child_key, child_value in obj.children :
      {
        name     = child_key
        children = try(child_value.children, {})
        scps     = try(child_value.ous, [])
        parent   = "${obj.parent}_${obj.name}"
        email    = try(child_value.email, "")
        key      = "${obj.parent}_${obj.name}_${child_key}"
  }]])
  level_3_objects = flatten([for obj in local.level_2_objects :
    [for child_key, child_value in obj.children :
      {
        name     = child_key
        children = try(child_value.children, {})
        scps     = try(child_value.ous, [])
        parent   = "${obj.parent}_${obj.name}"
        email    = try(child_value.email, "")
        key      = "${obj.parent}_${obj.name}_${child_key}"
  }]])
  level_4_objects = flatten([for obj in local.level_3_objects :
    [for child_key, child_value in obj.children :
      {
        name     = child_key
        children = try(child_value.children, {})
        scps     = try(child_value.ous, [])
        parent   = "${obj.parent}_${obj.name}"
        email    = try(child_value.email, "")
        key      = "${obj.parent}_${obj.name}_${child_key}"
  }]])

  root_ous    = { for obj in local.root_objects : obj.key => obj if obj.email == "" }
  level_1_ous = { for obj in local.level_1_objects : obj.key => obj if obj.email == "" }
  level_2_ous = { for obj in local.level_2_objects : obj.key => obj if obj.email == "" }
  level_3_ous = { for obj in local.level_3_objects : obj.key => obj if obj.email == "" }
  level_4_ous = { for obj in local.level_4_objects : obj.key => obj if obj.email == "" }

  all_objects = { for obj in flatten([
    local.root_objects,
    local.level_1_objects,
    local.level_2_objects,
    local.level_3_objects,
    local.level_4_objects,
    ]) : obj.key => obj
  }

  all_ou = { for obj_key, obj in local.all_objects : obj_key => obj if obj.email == "" }
  all_ou_attachments = { for attachment in flatten([for ou_key, ou_value in local.all_ou :
    [for scp in ou_value.scps : {
      key = ou_key
      scp = scp
  }]]) : "${attachment.key}_${attachment.scp}" => attachment }
  all_accounts = { for obj_key, obj in local.all_objects : obj_key => merge(obj, {
    environment : split("_", obj.parent)[length(split("_", obj.parent)) - 1]
  }) if obj.email != "" }
  all_ou_resources = merge(
    aws_organizations_organizational_unit.root_organizational_units,
    aws_organizations_organizational_unit.level_1_organizational_units,
    aws_organizations_organizational_unit.level_2_organizational_units,
    aws_organizations_organizational_unit.level_3_organizational_units,
  )

}

