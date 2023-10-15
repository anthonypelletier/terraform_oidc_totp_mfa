# Configuration de la méthode userpass
resource "vault_auth_backend" "userpass" {
  type        = "userpass"
  description = "Userpass auth method"
  path        = "userpass"
  tune {
    max_lease_ttl = "1h"
    listing_visibility = "unauth"
    default_lease_ttl = "1h"
  }
}

# Création d'un groupe pour tous les utilisateurs userpass
resource "vault_identity_group" "userpass_group" {
  name = "userpass-group"
  type = "internal"
  external_member_entity_ids = true # Indique que les membres sont gérés en externe, évitant les re-créations inutiles.
  policies = var.vault_policies # La politique que vous voulez attribuer à tous les membres du groupe
}