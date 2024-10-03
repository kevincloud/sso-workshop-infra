resource "tls_private_key" "saml_certificate" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "saml_certificate" {
  validity_period_hours = 87600
  private_key_pem       = tls_private_key.saml_certificate.private_key_pem

  subject {
    common_name  = "Workshop IdP"
    organization = "Expert Services"
    locality     = "San Francisco, California"
    country      = "US"
  }

  allowed_uses = [
    "client_auth",
    "data_encipherment",
    "digital_signature",
    "key_encipherment",
    "server_auth"
  ]
}
