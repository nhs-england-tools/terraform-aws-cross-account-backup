// Create a specific KMS key for the local backup vault and allow the remote 
// AWS account access to that key.

resource "aws_kms_alias" "remote_backup_vault_key" {
  name          = "alias/${var.instance_name}-remote-backup-vault-key"
  target_key_id = aws_kms_key.remote_backup_vault.key_id
}

resource "aws_kms_key" "remote_backup_vault" {
  description = "${var.instance_name} Remote Backup vault Key"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "key-default-plus",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.id}:root" 
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access from remote backup account",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${var.remote_account}:root"
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
                "AWS": "arn:aws:iam::${var.remote_account}:root"
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
