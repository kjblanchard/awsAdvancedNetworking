terraform {
  backend "s3" {
    bucket = "supergoon-terraform-plans"
    key    = "infra/terraform.tfstate"
    region = "us-east-2"
  }
}
