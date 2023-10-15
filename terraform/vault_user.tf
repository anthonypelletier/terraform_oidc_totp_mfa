# Création d'un utilisateur pour la méthode d'authentification userpass
resource "vault_generic_secret" "user" {
  depends_on = [
    vault_auth_backend.userpass,
  ]
  path = "auth/userpass/users/${var.vault_username}"

  data_json = jsonencode({
    password = var.vault_password,
    # policies = var.vault_policies
  })
}

# Création de l'entité identité pour l'utilisateur
resource "vault_identity_entity" "entity" {
  name = var.vault_username
  # policies = var.vault_policies
  metadata = {
    username_jwt = "${var.vault_username}#jwt"
    username_oidc = "${var.vault_username}#oidc"
  }
}

# Liez cette entité au groupe userpass
resource "vault_identity_group_member_entity_ids" "members" {
  depends_on = [
    vault_identity_group.userpass_group,
    vault_identity_entity.entity,
  ]
  group_id = vault_identity_group.userpass_group.id
  member_entity_ids = [vault_identity_entity.entity.id]
}

# Création de l'alias d'entité pour l'utilisateur via userpass
resource "vault_identity_entity_alias" "entity_alias_userpass" {
  depends_on = [
    vault_identity_entity.entity,
    vault_auth_backend.userpass
  ]
  name           = var.vault_username
  canonical_id   = vault_identity_entity.entity.id
  mount_accessor = vault_auth_backend.userpass.accessor
}

# Création de l'alias d'entité pour l'utilisateur via jwt
resource "vault_identity_entity_alias" "entity_alias_jwt" {
  depends_on = [
    vault_identity_entity.entity,
    vault_jwt_auth_backend.jwt
  ]
  name           = "${var.vault_username}#jwt"
  canonical_id   = vault_identity_entity.entity.id
  mount_accessor = vault_jwt_auth_backend.jwt.accessor
}

# Création de l'alias d'entité pour l'utilisateur via oidc
/* resource "vault_identity_entity_alias" "entity_alias_oidc" {
  depends_on = [
    vault_identity_entity.entity,
    vault_jwt_auth_backend.oidc
  ]
  name           = "${var.vault_username}#oidc"
  canonical_id   = vault_identity_entity.entity.id
  mount_accessor = vault_jwt_auth_backend.oidc.accessor
} */

# Configuration du TOTP pour l'entité utilisateur
resource "vault_generic_endpoint" "user_totp" {
  depends_on     = [
    vault_identity_mfa_totp.totp_method,
    vault_identity_entity.entity
  ]
  path           = "identity/mfa/method/totp/admin-generate"
  disable_read   = true
  disable_delete = true
  write_fields   = ["data", "barcode", "url"]

  data_json = jsonencode({
    method_id = vault_identity_mfa_totp.totp_method.method_id
    entity_id = vault_identity_entity.entity.id
  })
}

# Affichage du QRCode pour le TOTP
output "qr_code_link" {
  value = "data:image/png;base64,${vault_generic_endpoint.user_totp.write_data.barcode}"
  description = "QR code link for TOTP"
}
