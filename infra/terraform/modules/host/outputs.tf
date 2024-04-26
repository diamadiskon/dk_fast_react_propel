output "fa-app-chunk-skill-principal-id" {
  value = azurerm_linux_function_app.fa-app-chunk-skill.identity[0].principal_id
}
output "fa-app-kpi-analytics-principal-id" {
  value = azurerm_linux_function_app.fa-app-kpi-analytics.identity[0].principal_id

}
output "fa-app-snow-ingestion-principal-id" {
  value = azurerm_linux_function_app.fa-app-snow-ingestion.identity[0].principal_id

}

output "app-brainbank-dev-principal-id" {
  value = azurerm_linux_web_app.app-brainbank-chat-dev.identity[0].principal_id
}
output "app-brainbank-front-dev-principal-id" {
  value = azurerm_linux_web_app.app-brainbank-front-dev.identity[0].principal_id

}
output "app-brainbank-search-principal-id" {
  value = azurerm_linux_web_app.app-brainbank-search-dev.identity[0].principal_id

}
#################### Logic Apps Outputs ####################

output "logic-app-ca-principal-id" {

  value = azurerm_logic_app_standard.app-ca.identity[0].principal_id

}

output "logic-app-lsf-principal-id" {
  value = azurerm_logic_app_standard.app-lsf.identity[0].principal_id
}

output "logic-app-psf-principal-id" {
  value = azurerm_logic_app_standard.app-psf.identity[0].principal_id

}

output "logic-app-sectrim-principal-id" {
  value = azurerm_logic_app_standard.app-sectrim.identity[0].principal_id

}

output "logic-app-snitaf-principal-id" {
  value = azurerm_logic_app_standard.app-snitaf.identity[0].principal_id

}

output "logic-app-spi-principal-id" {
  value = azurerm_logic_app_standard.app-spi.identity[0].principal_id
}

output "app_brainbank_front_dev_url" {
  value = "${azurerm_linux_web_app.app-brainbank-front-dev.name}.azurewebsites.net"
}
