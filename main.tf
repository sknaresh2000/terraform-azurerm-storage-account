resource "azurerm_storage_account" "sa" {
  name                             = var.name
  resource_group_name              = var.rg_name
  location                         = var.location
  account_tier                     = var.account_tier
  account_replication_type         = var.account_replication_type
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  enable_https_traffic_only        = var.enable_https_traffic_only
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
  public_network_access_enabled    = var.public_network_access_enabled
  tags                             = var.tags
  dynamic "network_rules" {
    for_each = var.public_network_access_enabled == false && var.network_acls != null ? [1] : []
    content {
      bypass                     = var.network_acls.bypass_services_info
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.allowed_ips
      virtual_network_subnet_ids = var.network_acls.service_endpoint_subnet_ids
    }
  }
  dynamic "blob_properties" {
    for_each = var.blob_versioning_enabled ? [1] : []
    content {
      versioning_enabled = var.blob_versioning_enabled
    }
  }
}

resource "azurerm_private_endpoint" "pe" {
  name                = format("%s-%s", var.name, "private-endpoint")
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id
  private_service_connection {
    name                           = format("%s-%s", var.name, "private-service-connection")
    private_connection_resource_id = azurerm_storage_account.sa.id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = var.private_endpoint_sa_subresource_names
  }
}

resource "azurerm_storage_container" "container" {
  for_each              = var.container_info
  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = each.value.container_access_type
}