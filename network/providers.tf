
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
  alias = "east2"
  assume_role {
    role_arn = "arn:aws:iam::${terraform.workspace}:role/OrganizationAccountAccessRole"
  }
  default_tags {
    tags = var.provider_tags
  }
}

provider "aws" {
  region = "us-east-1"
  alias = "east1"
  assume_role {
    role_arn = "arn:aws:iam::${terraform.workspace}:role/OrganizationAccountAccessRole"
  }
  default_tags {
    tags = var.provider_tags
  }
}
