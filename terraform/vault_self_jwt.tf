# Configurer le backend d'authentification JWT pour pointer vers votre fournisseur OIDC Vault
resource "vault_jwt_auth_backend" "jwt" {
  depends_on = [
    vault_identity_oidc_provider.provider
  ]
  path                = "jwt"
  type                = "jwt"
  oidc_discovery_url = "https://vault.${var.DOMAIN}/v1/identity/oidc/provider/default"
  bound_issuer = "https://vault.${var.DOMAIN}/v1/identity/oidc/provider/default"
  default_role = "role_jwt_default"
  tune {
    default_lease_ttl = "1h"
    # listing_visibility = "unauth"
    max_lease_ttl = "1h"
  }
}

# Configurer un rôle pour l'authentification JWT
resource "vault_jwt_auth_backend_role" "role_jwt_default" {
  depends_on = [
    vault_jwt_auth_backend.jwt,
    vault_identity_oidc_client.client_public
  ]
  backend = vault_jwt_auth_backend.jwt.path
  role_name = "role_jwt_default"
  token_policies  = var.vault_policies
  bound_audiences = [vault_identity_oidc_client.client_public.client_id]
  user_claim            = "username_jwt"
  oidc_scopes = ["info"]
  # groups_claim = "groups"
  token_ttl = 600
  token_max_ttl = 600
  token_explicit_max_ttl = 600
  token_num_uses = 1

  role_type             = "jwt"
  allowed_redirect_uris = ["https://vault.${var.DOMAIN}/ui/vault/auth/oidc/oidc/callback"]
}