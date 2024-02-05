
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  assume_role {
    # role_arn     = "arn:aws:iam::123456789012:role/ROLE_NAME"
    role_arn = "arn:aws:iam::${terraform.workspace}:role/OrganizationAccountAccessRole"
    # session_name = "SESSION_NAME"
    # external_id  = "EXTERNAL_ID"
  }
  default_tags {
    tags = var.provider_tags
  }
}
