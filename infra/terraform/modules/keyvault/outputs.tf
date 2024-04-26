# Output Values

output "azurerm_key_vault_id" {
  value = azurerm_key_vault.brainbank_key_vault.id
}

output "azurerm_key_vault_certificate_id" {
  value = azurerm_key_vault_certificate.my_cert_1.id
}

output "azurerm_key_vault_certificate_name" {
  value = azurerm_key_vault_certificate.my_cert_1.name

}

output "azurerm_key_vault_certificate_secret_id" {
  value = azurerm_key_vault_certificate.my_cert_1.secret_id
}
output "azurerm_key_vault_certificate_version" {
  value = azurerm_key_vault_certificate.my_cert_1.version
}
