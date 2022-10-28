terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.29.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.3"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.30.0"
    }
  }
  required_version = ">= 1.0"
}
