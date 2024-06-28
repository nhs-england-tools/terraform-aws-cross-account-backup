// Output variable definitions

output "vault_arn" {
  description = "The Local backup vault ARN"
  value       = aws_backup_vault.remote_backup_vault.arn
}
