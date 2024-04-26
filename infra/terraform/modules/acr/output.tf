output "acr-server-url" {
  value = azurerm_container_registry.acr.login_server
}

output "acr-username" {
  value = azurerm_container_registry.acr.admin_username

}

output "acr-password" {
  value = azurerm_container_registry.acr.admin_password
}
