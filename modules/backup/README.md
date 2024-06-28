# Terraform module: backup schedules

## Description

This is a simple module to create a AWS Backup vault, KMS keys, Plans and automatic off-account site backup.

The vault module should be ran first in the remote AWS account.

**WARNING** Once a snaphshot has been placed intothe remote locked vault it can not be removed until the
 lifecycle duration has been exceeded.

## Module parameters

| Name             | Description                                              | Type   | Default             |
|:-----------------|:---------------------------------------------------------|:------:|:-------------------:|
| instance_name    | The name of the service being served                     | string | -                   |
| remote_account   | The AWS Account ID number of the remote account          | string | -                   |
| remote_vault_arn | The vault ARN in the remote account                      | string | false               |
| local_lifecycle  | Lifecycle for local copies, in days                      | number | -                   |
| remote_lifecycle | Lifecycle for remote copies, in days                     | number | -                   |
| backup_schedule  | The schedule to run backups, in AWS CRON format          | string | cron(15 11 ? * * *) |
| use_env          | Wether to backup by environmrnt ot ALL assets in account | bool   | false               |
| environment      | The environment name to select assets from               | string | -                   |


## Sample usage

This snippet creates a backup vault and plan for RSS prod. The AWS account number "123456789012" and ARN
 is the locked vault created by the vault module in a seperate AWS account.

Local copies of the snapshots are held for 7 days and remote "tamper-proof" copies for 90 days. The backup
 runs at 11:15 every day and backs up all assets in the prod environment (as defined by the Environment tag)
 with the BackupRemote Tag set to true

```
module "rss_prod_backup_vault" {
  source = "../modules/backup"

  instance_name      = "rss-prod"
  remote_accountount = "123456789012"
  remote_vault_arn   = "arn:aws:backup:eu-west-2:123456789012:backup-vault:rss_prod_backup"
  local_lifecycle    = 7
  remote_lifecycle   = 90
  backup_schedule    = "cron(15 11 ? * * *)"
  use_env            = true
  environment        = "prod"
}
```
