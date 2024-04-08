terraform {
  backend "s3" {
    encrypt              = true
    bucket               = "terraform-state-store-backup"
    workspace_key_prefix = "terraform-backup-automation"
    key                  = "terraform-backup-automation/terraform.tfstate"
    dynamodb_table       = "terraform-state-lock-backup"
    region               = "eu-west-2"
  }
}
