resource "aws_organizations_policy" "org_policies" {
  for_each    = var.policy
  name        = each.key
  description = each.value.description
  content     = jsondecode(jsonencode(file("./policy_json/${each.value.file}.json")))
}

resource "aws_organizations_policy_attachment" "ou_policy_attachments" {
  for_each  = local.all_ou_attachments
  policy_id = lookup(aws_organizations_policy.org_policies, each.value.scp).id
  target_id = lookup(local.all_ou_resources, each.value.key).id
}
