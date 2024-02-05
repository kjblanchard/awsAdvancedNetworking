output "account_numbers" {
  value = {
    for account_key, account in aws_organizations_account.account : account_key => account.id
  }
}
