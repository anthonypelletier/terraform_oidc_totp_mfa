provider "vault" {
  address = "https://vault.${var.DOMAIN}"
  token   = "${var.VAULT_TOKEN}"
}
