
resource "azurerm_key_vault" "brainbank_key_vault" {
  name                          = "kv-${var.workload}-${var.environment}-${var.location_abbreviation}001"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enabled_for_disk_encryption   = true
  tenant_id                     = var.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  sku_name                      = "standard"
  public_network_access_enabled = true



  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id


    key_permissions = [
      "Get", "Create", "List"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Backup", "Restore", "Recover", "Purge"
    ]

    storage_permissions = [
      "Get", "Set", "List"
    ]

    certificate_permissions = [
      "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
    ]
  }
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    virtual_network_subnet_ids = [var.subnet_agw_id]

  }



}


# Resource-4: Import the SSL certificate into Key Vault and store the certificate SID in a variable
resource "azurerm_key_vault_certificate" "my_cert_1" {

  name         = "my-cert-1"
  key_vault_id = azurerm_key_vault.brainbank_key_vault.id

  certificate {
    contents = filebase64("${path.module}/ssl-self-signed/myapplicationgateway.pfx")
    password = "ABC123!@#"
  }


}

resource "azurerm_key_vault_access_policy" "agw_aceess_policy" {
  key_vault_id = azurerm_key_vault.brainbank_key_vault.id
  tenant_id    = var.tenant_id
  object_id    = var.agw_object_id //need principal id of the user assigned identity

  key_permissions = [
    "Get", "List"
  ]

  secret_permissions = [
    "Get", "List"
  ]
  certificate_permissions = ["Get", "List"]
}


// Private Endpoint

resource "azurerm_private_endpoint" "pep-kv" {
  name                = "pep-kv-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_private_id
  private_service_connection {
    name                           = "kv-private-service-connection"
    private_connection_resource_id = azurerm_key_vault.brainbank_key_vault.id
    is_manual_connection           = false
    subresource_names              = ["Vault"]
  }
}
