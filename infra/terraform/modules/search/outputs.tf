output "search_service_id" {
  value = azurerm_search_service.search_service.id
}
output "search_service_principal_id" {
  value = azurerm_search_service.search_service.identity[0].principal_id
}
