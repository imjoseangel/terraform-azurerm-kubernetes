terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.53.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
  required_version = ">= 1.0"
}
