// Create the AWS Backup Vault and plans

// The vault

resource "aws_backup_vault" "remote_backup_vault" {
  name        = "${var.instance_name}-remote_backup"
  kms_key_arn = aws_kms_key.remote_backup_vault.arn
}

// The policy to use for the vault allowing the remote AWS account to copy snapshots
// back in case of incidents

resource "aws_backup_vault_policy" "remote_backup" {
  backup_vault_name = aws_backup_vault.remote_backup_vault.name

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
                    "arn:aws:iam::${var.remote_account}:root"
                ]
            }
        }
    ]
}
POLICY
}

// The backup plan which automatically copies snapshots off-account

resource "aws_backup_plan" "remote_backup" {
  name = "${var.instance_name}-remote_backup"

  rule {
    rule_name         = "${var.instance_name}-remote_backup"
    target_vault_name = aws_backup_vault.remote_backup_vault.name
    schedule          = var.backup_schedule

    lifecycle {
      delete_after = var.local_lifecycle
    }
    copy_action {
      destination_vault_arn = var.remote_vault_arn

      lifecycle {
        delete_after = var.remote_lifecycle
      }
    }
  }
}

// A selection which backs up ALL assets in the AWS account which have
// the tag BackupRemote=True

resource "aws_backup_selection" "remote_backup_account" {
  count        = var.use_env ? 0 : 1
  iam_role_arn = aws_iam_role.remote_backup.arn
  name         = "${var.instance_name}-remote-backup-account"
  plan_id      = aws_backup_plan.remote_backup.id
  resources    = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/BackupRemote"
      value = "true"
    }
  }
}

// A selection which backs up assets in the AWS account which have
// the tag BackupRemote=True AND the requested Environment tag.

resource "aws_backup_selection" "remote_backup_env" {
  count        = var.use_env ? 1 : 0
  iam_role_arn = aws_iam_role.remote_backup.arn
  name         = "${var.instance_name}-remote-backup-env"
  plan_id      = aws_backup_plan.remote_backup.id
  resources    = ["*"]

  condition {
    string_equals {
      key   = "aws:ResourceTag/BackupRemote"
      value = "true"
    }
    string_equals {
      key   = "aws:ResourceTag/Environment"
      value = var.environment
    }
  }
}
