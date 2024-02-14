module "pingbots" {
  for_each            = {for subnet in local.pingbot_subnets: subnet.name => subnet}
  source              = "../ec2"
  instance_profile_name = var.pingbot_instance_profile_name
  security_group_id   = aws_security_group.pingbot.id
  subnet_id = aws_subnet.private[each.key].id
  name = each.key
}

module "bastion" {
  count            = length(local.bastion_subnets) > 0 ? 1 : 0
  source              = "../ec2"
  security_group_id   = local.security_group_ids["bastion"]
  subnet_id = aws_subnet.public[local.bastion_subnets[0].name].id
  key_pair = aws_key_pair.ec2.key_name
  name = "Bastion-KJB"
}