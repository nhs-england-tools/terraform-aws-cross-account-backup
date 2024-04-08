terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.27.0"
    }
  }
  required_version = ">= 1.3.6"
}

# Provider definition for the central backup account
provider "aws" {
  alias  = "backup"
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${var.backup_account_id}:role/OrganizationAccountAccessRole"
  }
}

# Provider definition for the member account
provider "aws" {
  alias  = "target"
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${var.target_account_id}:role/OrganizationAccountAccessRole"
  }
}
