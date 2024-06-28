# Output variable definitions

output "vault_arn" {
  description = "The vault ARN"
  value       = aws_backup_vault.backup.arn
}
