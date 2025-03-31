terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "3.2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
  }
  required_version = ">= 1.0"
}
