# Configurer le backend d'authentification OIDC pour pointer vers votre fournisseur OIDC Vault
/* resource "vault_jwt_auth_backend" "oidc" {
  depends_on = [
    vault_identity_oidc_provider.provider,
    vault_identity_oidc_client.client_confidential
  ]
  path                = "oidc"
  type                = "oidc"
  oidc_discovery_url = "https://vault.${var.DOMAIN}/v1/identity/oidc/provider/default"
  bound_issuer = "https://vault.${var.DOMAIN}/v1/identity/oidc/provider/default"
  oidc_client_id = vault_identity_oidc_client.client_confidential.client_id
  oidc_client_secret = vault_identity_oidc_client.client_confidential.client_secret
  default_role = "role_oidc_default"
  tune {
    default_lease_ttl = "1h"
    listing_visibility = "unauth"
    max_lease_ttl = "1h"
  }
}

# Configurer un rôle pour l'authentification OIDC
resource "vault_jwt_auth_backend_role" "role_oidc_default" {
  depends_on = [
    vault_jwt_auth_backend.oidc,
    vault_identity_oidc_client.client_confidential
  ]
  backend = vault_jwt_auth_backend.oidc.path
  role_name = "role_oidc_default"
  token_policies  = var.vault_policies
  bound_audiences = [vault_identity_oidc_client.client_confidential.client_id]
  user_claim            = "username_oidc"
  oidc_scopes = ["info"]
  # groups_claim = "groups"
  token_ttl = 600
  token_max_ttl = 600
  token_explicit_max_ttl = 600
  token_num_uses = 1

  role_type             = "oidc"
  allowed_redirect_uris = ["https://vault.${var.DOMAIN}/ui/vault/auth/oidc/oidc/callback"]
} */
