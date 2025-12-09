terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.96"   # your version is okay
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      # Allows terraform destroy even if alert rules exist
      prevent_deletion_if_contains_resources = false
    }
  }

  # IMPORTANT ⚠️ Since you are Contributor, Terraform cannot auto-register providers
  resource_provider_registrations = "none"
}

# Needed to fetch tenant_id + object_id
data "azurerm_client_config" "current" {}
