output "users_login_url" {
  description = "The base login URL used by workshop users to log in to the workshop platform."
  value       = "${module.api_gateway.api_url}/login"
}

output "users_table_name" {
  description = "The DynamoDB table name to write new user records to, adding them to the workshop platform."
  value       = module.users_dynamodb_table.table_name
}

output "certificate_pem" {
  description = "The Certificate used in the SAML signing process, to be set in the workshop platform SAML/SSO configuration."
  value       = tls_self_signed_cert.saml_certificate.cert_pem
}
