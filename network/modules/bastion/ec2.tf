module "ec2" {
  source = "../ec2"
  subnet_id = var.subnet_id
  name = var.name
}
