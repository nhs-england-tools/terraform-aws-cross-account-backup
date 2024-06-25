# Input variable definitions

variable "client_name" {
  description = "The name of the client being served"
  type        = string
}

variable "client_account" {
  description = "The AWS Account ID number being served"
  type        = string
}

variable "lock_vault" {
  description = "Whether to lock the vault"
  type        = bool
  default     = false
}
