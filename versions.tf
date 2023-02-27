terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.45.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.35.0"
    }
  }
  required_version = ">= 1.0"
}
