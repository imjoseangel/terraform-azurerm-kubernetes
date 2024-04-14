terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.99.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.48.0"
    }
  }
  required_version = ">= 1.0"
}
