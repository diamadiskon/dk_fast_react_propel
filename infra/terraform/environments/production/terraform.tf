terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.4"
    }
  }

}

provider "azurerm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  use_oidc        = false
  features {}
}

provider "local" {}
