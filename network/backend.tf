terraform {
  backend "s3" {
    bucket = "supergoon-terraform-plans"
    key    = "networks/terraform.tfstate"
    region = "us-east-2"
  }
}
