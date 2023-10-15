# Configuration de la méthode TOTP
resource "vault_identity_mfa_totp" "totp_method" {
  issuer    = "vault"
  period    = 30
  key_size  = 20
  qr_size   = 200
  algorithm = "SHA1"
  digits    = 6
  skew      = 1
}

# Applique la méthode TOTP à la méthode d'authentification oidc
/* resource "vault_identity_mfa_login_enforcement" "totp_assos" {
  depends_on = [
    vault_identity_mfa_totp.totp_method,
    vault_auth_backend.userpass,
    # vault_jwt_auth_backend.oidc
  ]
  name                     = "totp_assos"
  mfa_method_ids           = [vault_identity_mfa_totp.totp_method.method_id]
  auth_method_accessors    = [vault_auth_backend.userpass.accessor]
  # auth_method_accessors    = [vault_jwt_auth_backend.oidc.accessor]
} */
