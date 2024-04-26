# resource "azurerm_storage_account" "storageaccount" {
#   name                            = "st${var.workload}${var.environment}${var.location_abbreviation}"
#   resource_group_name             = var.resource_group_name
#   location                        = var.location
#   account_tier                    = "Standard"
#   account_replication_type        = "LRS"
#   public_network_access_enabled   = true
#   allow_nested_items_to_be_public = true

#   # network_rules {
#   #   default_action = "Deny"
#   #   bypass         = ["AzureServices"]
#   #   ip_rules       = ["212.54.204.130"]
#   # }
# }

# resource "azurerm_storage_share" "share" {
#   name                 = "share${var.workload}${var.environment}${var.location_abbreviation}"
#   storage_account_name = azurerm_storage_account.storageaccount.name
#   quota                = 50
#   depends_on = [
#     azurerm_storage_account.storageaccount
#   ]
# }

# resource "azurerm_storage_account_network_rules" "storage_rules" {
#   storage_account_id         = azurerm_storage_account.storageaccount.id
#   default_action             = "Deny"
#   virtual_network_subnet_ids = [var.subnet_logic_apps_id]
# }

# # resource "azurerm_private_endpoint" "blob_private_endpoint" {
# #   name                = "storage-endpoint"
# #   location            = var.location
# #   resource_group_name = var.resource_group_name
# #   subnet_id           = var.subnet_private_id

# #   private_service_connection {
# #     name                           = "storage-endpoint-connection"
# #     private_connection_resource_id = azurerm_storage_account.storageaccount.id
# #     subresource_names              = ["blob"]
# #     is_manual_connection           = false
# #   }

# #   depends_on = [
# #     azurerm_storage_account.storageaccount
# #   ]
# # }

# # resource "azurerm_private_endpoint" "table_private_endpoint" {
# #   name                = "storage-blob-endpoint"
# #   location            = var.location
# #   resource_group_name = var.resource_group_name
# #   subnet_id           = var.subnet_private_id

# #   private_service_connection {
# #     name                           = "storage-table-endpoint-connection"
# #     private_connection_resource_id = azurerm_storage_account.storageaccount.id
# #     subresource_names              = ["table"]
# #     is_manual_connection           = false
# #   }

# #   depends_on = [
# #     azurerm_storage_account.storageaccount
# #   ]
# # }

# # resource "azurerm_private_endpoint" "file-private_endpoint" {
# #   name                = "storage-file-endpoint"
# #   location            = var.location
# #   resource_group_name = var.resource_group_name
# #   subnet_id           = var.subnet_private_id

# #   private_service_connection {
# #     name                           = "storage-file-endpoint-connection"
# #     private_connection_resource_id = azurerm_storage_account.storageaccount.id
# #     subresource_names              = ["file"]
# #     is_manual_connection           = false
# #   }

# #   depends_on = [
# #     azurerm_storage_account.storageaccount
# #   ]
# # }

# # resource "azurerm_private_endpoint" "queue_private_endpoint" {
# #   name                = "storage-queue-endpoint"
# #   location            = var.location
# #   resource_group_name = var.resource_group_name
# #   subnet_id           = var.subnet_private_id


# #   private_service_connection {
# #     name                           = "storage-queue-endpoint-connection"
# #     private_connection_resource_id = azurerm_storage_account.storageaccount.id
# #     subresource_names              = ["queue"]
# #     is_manual_connection           = false
# #   }

# #   depends_on = [
# #     azurerm_storage_account.storageaccount
# #   ]
# # }



# ################### MUST BE COMMENTED OUT  IF YOU RUN IT TWICE ############################

# # resource "azurerm_search_shared_private_link_service" "srctostorageconnectionblob" {
# #   name               = "blob-sa-src-${var.workload}-${var.environment}-${var.location_abbreviation}"
# #   search_service_id  = var.search_service_id
# #   subresource_name   = "blob"
# #   target_resource_id = azurerm_storage_account.storageaccount.id
# #   request_message    = "Please Approve"

# #   depends_on = [
# #     azurerm_storage_account.storageaccount, azurerm_private_endpoint.blob_private_endpoint
# #   ]

# # }

# # resource "azurerm_search_shared_private_link_service" "srctostorageconnectiontable" {
# #   name               = "table-sa-src-${var.workload}-${var.environment}-${var.location_abbreviation}"
# #   search_service_id  = var.search_service_id
# #   subresource_name   = "table"
# #   target_resource_id = azurerm_storage_account.storageaccount.id
# #   request_message    = "Please Approve"
# #   depends_on = [
# #   azurerm_storage_account.storageaccount, azurerm_search_shared_private_link_service.srctostorageconnectionblob, azurerm_private_endpoint.table_private_endpoint]

# # }

# # resource "azurerm_search_shared_private_link_service" "srctostorageconnectionfile" {
# #   name               = "file-sa-src-${var.workload}-${var.environment}-${var.location_abbreviation}"
# #   search_service_id  = var.search_service_id
# #   subresource_name   = "file"
# #   target_resource_id = azurerm_storage_account.storageaccount.id
# #   request_message    = "Please Approve"
# #   depends_on = [
# #     azurerm_storage_account.storageaccount, azurerm_private_endpoint.file-private_endpoint
# #   ]

# # }

# # resource "azurerm_search_shared_private_link_service" "srctostorageconnectionqueue" {
# #   name               = "dfs-sa-src-${var.workload}-${var.environment}-${var.location_abbreviation}"
# #   search_service_id  = var.search_service_id
# #   subresource_name   = "dfs"
# #   target_resource_id = azurerm_storage_account.storageaccount.id
# #   request_message    = "Please Approve"

# #   depends_on = [
# #     azurerm_storage_account.storageaccount, azurerm_private_endpoint.queue_private_endpoint
# #   ]

# # }
