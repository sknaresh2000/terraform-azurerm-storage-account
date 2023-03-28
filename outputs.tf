output "id" {
  value       = azurerm_storage_account.sa.id
  description = "The id of the created storage account"
}

output "primary_blob_endpoint" {
  value       = azurerm_storage_account.sa.primary_blob_endpoint
  description = "The endpoint URL for blob storage in the primary location"
}

output "container_names" {
  value       = var.container_info == {} ? null : azurerm_storage_container.container[*].name
  description = "The names of the Storage Container that were created"
}