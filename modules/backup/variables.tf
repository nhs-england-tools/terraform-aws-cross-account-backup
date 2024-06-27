// Input variable definitions

variable "instance_name" {
  description = "The name of the service being served"
  type        = string
}

variable "remote_account" {
  description = "The AWS accound ID number holding the remote locked vault"
  type        = string
}

variable "remote_vault_arn" {
  description = "The ARN of the locked vault to copy snaphsots too in the remote AWS account"
  type        = string
}

variable "local_lifecycle" {
  description = "The lifecycle used for local backup snaphots, in days"
  type        = string
}

variable "remote_lifecycle" {
  description = "The lifecycle used for remote backup snaphots, in days"
  type        = string
}

variable "backup_schedule" {
  description = "The schedule to run backups in, in AWS's CRON format"
  type        = string
  default     = "cron(15 11 ? * * *)"
}

variable "use_env" {
  description = ""
  type        = bool
  default     = false
}

variable "environment" {
  description = "The environment name to back up, if omitted then ALL assets in the AWS account will be backed up if requested."
  type        = string
}
