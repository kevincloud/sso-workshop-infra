variable "application_name" {
  description = "The application to which the infrastructure belongs."
  type        = string
  default     = "workshop-infrastructure"
}

variable "environment_name" {
  description = "The environment to which the infrastructure belongs."
  type        = string
  default     = "production"
}

variable "maintainer_email" {
  description = "The email address of the maintainer for the infrastructure."
  type        = string
}

variable "users_table_name_parameter_name" {
  description = "The parameter name holding the name of the DynamoDB table that user details are stored in."
  type        = string
  default     = "users"
}

variable "saml_audience_parameter_name" {
  description = "The audience parameter name for SAML responses."
  type        = string
  default     = "saml-audience"
}

variable "saml_certificate_parameter_name" {
  description = "The certificate parameter name to use for SAML response signing."
  type        = string
  default     = "saml-certificate"
}

variable "saml_private_key_parameter_name" {
  description = "The private key parameter name to use for SAML response signing."
  type        = string
  default     = "saml-private-key"
}

variable "saml_issuer_parameter_name" {
  description = "The issuer parameter name for SAML responses."
  type        = string
  default     = "saml-issuer"
}

variable "saml_recipient_parameter_name" {
  description = "The recipient attribute name for SAML responses, and the URL to redirect to after a successful SAML response is generated."
  type        = string
  default     = "saml-recipient"
}

variable "saml_audience" {
  description = "The audience parameter value for SAML responses."
  type        = string
}

variable "saml_recipient" {
  description = "The recipient attribute value for SAML responses, and the URL to redirect to after a successful SAML response is generated."
  type        = string
}
