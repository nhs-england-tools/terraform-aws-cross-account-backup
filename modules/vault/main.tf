resource "aws_backup_vault" "backup" {
  name        = "${replace(var.client_name, "-", "_")}_backup"
  kms_key_arn = aws_kms_key.backup.arn
}

resource "aws_backup_vault_lock_configuration" "backup" {
  count               = var.lock_vault ? 1 : 0
  backup_vault_name   = aws_backup_vault.backup.name
  changeable_for_days = 8
}

resource "aws_backup_vault_policy" "backup" {
  backup_vault_name = aws_backup_vault.backup.name

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "backup:CopyIntoBackupVault",
            "Resource": "*",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.client_account}:root"
                ]
            }
        }
    ]
}
POLICY
}

resource "aws_kms_alias" "backup" {
  name          = "alias/backup-vault-key/${var.client_name}"
  target_key_id = aws_kms_key.backup.key_id
}

resource "aws_kms_key" "backup" {
  description = "${var.client_name} Backup Vault Key"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "key-default-plus",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${local.service_account}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access from remote backup account",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${var.client_account}:root"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistant resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.client_account}:root"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
POLICY
}