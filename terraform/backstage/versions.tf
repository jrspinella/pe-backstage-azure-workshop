terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.111"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13"
    }
  }
  required_version = ">= 1.1.0"
}

data "azurerm_client_config" "current" {}

provider "azuread" {
  environment = "usgovernment"
  tenant_id = data.azurerm_client_config.current.tenant_id
}

provider "azurerm" {
  environment = "usgovernment"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "local_file" "kubeconfig" {
  content  = data.azurerm_kubernetes_cluster.aks.kube_config_raw
  filename = var.kubconfig_path
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}

provider "random" {}