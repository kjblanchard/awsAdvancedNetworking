# module "ec2" {
#   for_each            = var.network.pingbots ? toset(["one", "two"]) : toset([])
#   source              = "../ec2"
#   instance_profile_name = var.pingbot_instance_profile_name
#   security_group_id   = aws_security_group.pingbot.id
#   subnet_id = aws_subnet.main["web_us_east_1c"].id
#   name = each.key
# }
