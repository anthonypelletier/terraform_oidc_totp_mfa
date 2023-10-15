# Création d'une entité OIDC key
resource "vault_identity_oidc_key" "key" {
  name               = "default"
  allowed_client_ids = ["*"]
  rotation_period    = 86400
  verification_ttl   = 86400
}


# Création d'une entité OIDC assignment
resource "vault_identity_oidc_assignment" "assignment" {
  depends_on = [
    vault_identity_group.userpass_group
  ]
  name       = "my-assignment"
  group_ids  = [vault_identity_group.userpass_group.id] # Remplacez par votre ID de groupe
}

# Création d'une entité OIDC client public
resource "vault_identity_oidc_client" "client_public" {
  depends_on = [
    vault_identity_oidc_key.key,
    vault_identity_oidc_assignment.assignment
  ]
  name          = "client_public"
  key           = vault_identity_oidc_key.key.name
  redirect_uris = [
    "https://app.${var.DOMAIN}/callback",
    "https://app.${var.DOMAIN}/api/docs/oauth2-redirect",
    "http://127.0.0.1:8000/docs/oauth2-redirect",
    "https://vault.${var.DOMAIN}/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8200/oidc/callback",
    "http://localhost:8250/oidc/callback",
    "http://localhost:5173/callback",
    "http://127.0.0.1:5173/callback",
  ]
  assignments   = [vault_identity_oidc_assignment.assignment.name]
  id_token_ttl     = 3600
  access_token_ttl = 3600
  client_type = "public" # Pour PKCE
}

# Création d'une entité OIDC client confidential
resource "vault_identity_oidc_client" "client_confidential" {
  depends_on = [
    vault_identity_oidc_key.key,
    vault_identity_oidc_assignment.assignment
  ]
  name          = "client_confidential"
  key           = vault_identity_oidc_key.key.name
  redirect_uris = [
    "https://app.${var.DOMAIN}/callback",
    "https://app.${var.DOMAIN}/api/docs/oauth2-redirect",
    "http://127.0.0.1:8000/docs/oauth2-redirect",
    "https://vault.${var.DOMAIN}/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8200/oidc/callback",
    "http://localhost:8250/oidc/callback",
    "http://localhost:5173/callback",
    "http://127.0.0.1:5173/callback",
  ]
  assignments   = [vault_identity_oidc_assignment.assignment.name]
  id_token_ttl     = 3600
  access_token_ttl = 3600
  client_type = "confidential"
}


# Création d'une entité OIDC scope
resource "vault_identity_oidc_scope" "scope" {
  name        = "info"
  # template    = jsonencode({
    # username = "{{identity.entity.name}}"
  # })
  # template = "{\"username\":{{identity.entity.name}},\"username_jwt\":{{identity.entity.metadata.username_jwt}},\"username_oidc\":{{identity.entity.metadata.username_oidc}}}"
  template = "{\"username\":{{identity.entity.name}},\"username_jwt\":{{identity.entity.metadata.username_jwt}}}"
  description = "infos scope."
}

# Création d'une entité OIDC provider
resource "vault_identity_oidc_provider" "provider" {
  depends_on = [
    vault_identity_oidc_client.client_public,
    vault_identity_oidc_client.client_confidential,
    vault_identity_oidc_scope.scope
  ]
  name = "default"
  https_enabled = true
  issuer_host = "vault.${var.DOMAIN}"
  allowed_client_ids = [
    vault_identity_oidc_client.client_public.client_id,
    vault_identity_oidc_client.client_confidential.client_id,
  ]
  scopes_supported = [
    vault_identity_oidc_scope.scope.name
  ]
}

# Affichage du client_id pour l'application public
output "application_client_id" {
  value = vault_identity_oidc_client.client_public.client_id
  description = "client_id for client public"
}