module "ssm_parameters" {
  source = "./modules/ssm-parameters"

  application_name     = var.application_name
  environment_name     = var.environment_name
  maintainer_email     = var.maintainer_email
  parameter_group_name = "default"

  parameters = {
    (var.saml_audience_parameter_name) : {
      Type  = "String"
      Value = var.saml_audience
    }

    (var.saml_issuer_parameter_name) : {
      Type  = "String"
      Value = "${module.api_gateway.api_url}/login"
    }

    (var.saml_recipient_parameter_name) : {
      Type  = "String"
      Value = var.saml_recipient
    }

    (var.users_table_name_parameter_name) : {
      Type  = "String"
      Value = module.users_dynamodb_table.table_name
    }

    (var.saml_certificate_parameter_name) : {
      Type  = "SecureString"
      Value = tls_self_signed_cert.saml_certificate.cert_pem
    }

    (var.saml_private_key_parameter_name) : {
      Type  = "SecureString"
      Value = tls_self_signed_cert.saml_certificate.private_key_pem
    }
  }
}