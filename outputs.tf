output "id" {
  value       = azurerm_storage_account.sa.id
  description = "The id of the created storage account"
}

output "primary_blob_endpoint " {
  value       = azurerm_storage_account.sa.primary_blob_endpoint
  description = "The endpoint URL for blob storage in the primary location"
}