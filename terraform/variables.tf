variable "DOMAIN" { }

variable "vault_url" {
  description = "URL de l'instance Vault."
  type        = string
  default     = "https://vault.${var.DOMAIN}"
}

variable "vault_token" {
  description = "Token d'accès root pour Vault. Ceci devrait être conservé en sécurité et, idéalement, ne pas être codé en dur ici."
  type        = string
  default     = "root_token"
  sensitive   = true
}

variable "vault_username" {
  description = "Nom d'utilisateur pour la méthode d'authentification userpass."
  type        = string
  default     = "admin"
}

variable "vault_password" {
  description = "Mot de passe pour la méthode d'authentification userpass."
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "vault_policies" {
  description = "Politiques à associer à l'utilisateur."
  type        = list(string)
  default     = ["default"]
}

variable "totp_issuer" {
  description = "Nom du fournisseur pour la méthode TOTP."
  type        = string
  default     = "vault"
}

variable "totp_period" {
  description = "Période en secondes pour le TOTP."
  type        = number
  default     = 30
}

variable "totp_key_size" {
  description = "Taille de la clé pour le TOTP."
  type        = number
  default     = 20
}

variable "totp_qr_size" {
  description = "Taille de l'image QR pour le TOTP."
  type        = number
  default     = 200
}

variable "totp_algorithm" {
  description = "Algorithme à utiliser pour le TOTP."
  type        = string
  default     = "SHA1"
}

variable "totp_digits" {
  description = "Nombre de chiffres pour le TOTP."
  type        = number
  default     = 6
}

variable "totp_skew" {
  description = "Skew autorisé pour le TOTP."
  type        = number
  default     = 1
}

variable "totp_max_validation_attempts" {
  description = "Nombre maximal de tentatives de validation pour le TOTP."
  type        = number
  default     = 5
}
