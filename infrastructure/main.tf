module "backup-account" {
  source = "./modules/backup-account"
  providers = {
    aws = aws.backup
  }
  backup_account_id = var.backup_account_id
  org_id            = var.org_id
}

module "member-account" {
  source = "./modules/member-account"
  providers = {
    aws = aws.target
  }
  count             = (var.target_account_id != var.backup_account_id) ? 1 : 0
  target_account_id = var.target_account_id
  backup_account_id = var.backup_account_id
  org_id            = var.org_id
}
