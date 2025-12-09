########################################
# Resource Group
########################################

resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-rg"
  location = var.location
}

########################################
# Storage Account
########################################

resource "azurerm_storage_account" "sa" {
  name                     = "${var.project_name}sa987"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"
}

########################################
# Application Insights
########################################

resource "azurerm_application_insights" "ai" {
  name                = "${var.project_name}-ai"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_type    = "other"
}

########################################
# Key Vault
########################################

resource "azurerm_key_vault" "kv" {
  name                       = "${var.project_name}kv"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  # Allow current user (you) to manage secrets
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "List", "Set", "Delete"]
  }
}

########################################
# Store Azure OpenAI settings in KV
########################################

resource "azurerm_key_vault_secret" "aoai_endpoint" {
  name         = "azure-openai-endpoint"
  value        = var.azure_openai_endpoint
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "aoai_api_key" {
  name         = "azure-openai-api-key"
  value        = var.azure_openai_api_key
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "aoai_deployment" {
  name         = "azure-openai-deployment"
  value        = var.azure_openai_deployment
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "aoai_api_version" {
  name         = "azure-openai-api-version"
  value        = var.azure_openai_api_version
  key_vault_id = azurerm_key_vault.kv.id
}

########################################
# Key Vault access for EXISTING Function App identity
########################################

resource "azurerm_key_vault_access_policy" "func_policy" {
  key_vault_id = azurerm_key_vault.kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id

  # 👇 Your existing Function App's managed identity object id
  object_id = "b5c8b279-4e5b-4dfd-9a5d-c7ad2d1a73aa"

  secret_permissions = [
    "Get",
    "List"
  ]
}
