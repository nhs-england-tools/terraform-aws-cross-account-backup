data "aws_caller_identity" "current" {
}

locals {
  service_account = data.aws_caller_identity.current.account_id
}
