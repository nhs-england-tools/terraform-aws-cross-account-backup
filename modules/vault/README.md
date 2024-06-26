# Terraform module: vault

## Description

This is a simple module to create a AWS Backup vault set up to act as a destination for
remote off-account AWS backup copy jobs. The vault can be "locked" which prevents
pre-mature backup snapshot deletion.

The vault should be located in an isolated AWS account

**WARNING** Once a vault is locked you have 8 days to reverse the setting. Once this
cool-off period has been passed vault locking can not be removed.

## Module parameters

| Name           | Description                            | Type   | Default|
|:---------------|:---------------------------------------|:------:|:------:|
| client_name    | The name of the client being served    | string | -      |
| client_account | The AWS Account ID number being served | string | -      |
| lock_vault     | Whether to lock the vault              | bool   | false  | 

## Sample usage

This snippet creates a locked vault for RSS prod backup called rss-prod. The AWS account
number "123456789012" is the only account which can copy backup snapshots into this
vault. (Only one account is allowed to copy into each vault so as to ensure data
segregation).

```
module "rss_prod_prod_backup_vault" {
  source = "../modules/vault"

  client_name    = "rss-prod"
  client_account = "123456789012"
  lock_vault     = true
}
```
