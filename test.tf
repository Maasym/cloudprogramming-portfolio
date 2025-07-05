data "aws_caller_identity" "current" {}


output "test_aws_account_id" {
  value       = data.aws_caller_identity.current.account_id
}