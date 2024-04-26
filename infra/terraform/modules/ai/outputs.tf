output "formrecognizer-principal-id" {
  value = azurerm_cognitive_account.form_recognizer_account.identity[0].principal_id
}
