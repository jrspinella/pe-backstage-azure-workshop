data "azurerm_subscription" "current" {}

################################################################################
# Resource Group: Resource
################################################################################
resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = local.location
  tags     = var.tags
}

################################################################################
# Virtual Network: Module
################################################################################

module "network" {
  source              = "Azure/subnets/azurerm"
  version             = "1.0.0"
  resource_group_name = azurerm_resource_group.this.name
  subnets = {
    aks = {
      address_prefixes  = ["10.52.0.0/16"]
      service_endpoints = ["Microsoft.Storage"]
    }
  }
  virtual_network_address_space = ["10.52.0.0/16"]
  virtual_network_location      = azurerm_resource_group.this.location
  virtual_network_name          = "vnet1"
  virtual_network_tags          = var.tags
}

################################################################################
# AKS: Module
################################################################################

module "aks" {
  source                                          = "Azure/aks/azurerm"
  version                                         = "9.4.1"
  resource_group_name                             = azurerm_resource_group.this.name
  location                                        = var.location
  kubernetes_version                              = var.kubernetes_version
  orchestrator_version                            = var.kubernetes_version
  role_based_access_control_enabled               = var.role_based_access_control_enabled
  rbac_aad                                        = var.rbac_aad
  prefix                                          = var.prefix
  network_plugin                                  = var.network_plugin
  vnet_subnet_id                                  = lookup(module.network.vnet_subnets_name_id, "aks")
  os_disk_size_gb                                 = var.os_disk_size_gb
  os_sku                                          = var.os_sku
  sku_tier                                        = var.sku_tier
  private_cluster_enabled                         = var.private_cluster_enabled
  enable_auto_scaling                             = var.enable_auto_scaling
  enable_host_encryption                          = var.enable_host_encryption
  log_analytics_workspace_enabled                 = var.log_analytics_workspace_enabled
  agents_min_count                                = var.agents_min_count
  agents_max_count                                = var.agents_max_count
  agents_count                                    = null # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                                 = var.agents_max_pods
  agents_pool_name                                = "system"
  agents_availability_zones                       = ["1", "2", "3"]
  agents_type                                     = "VirtualMachineScaleSets"
  agents_size                                     = var.agents_size
  monitor_metrics                                 = {}
  azure_policy_enabled                            = var.azure_policy_enabled
  microsoft_defender_enabled                      = var.microsoft_defender_enabled
  tags                                            = var.tags
  green_field_application_gateway_for_ingress     = var.green_field_application_gateway_for_ingress
  create_role_assignments_for_application_gateway = var.create_role_assignments_for_application_gateway

  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  ################################################################################
  # Identity AKS
  ################################################################################
  //client_id = azuread_application.akspe-app.application_id
  //client_secret = azuread_service_principal_password.akspe-sp-password.value

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  network_policy             = var.network_policy
  net_profile_dns_service_ip = var.net_profile_dns_service_ip
  net_profile_service_cidr   = var.net_profile_service_cidr

  network_contributor_role_assigned_subnet_ids = { "aks" = lookup(module.network.vnet_subnets_name_id, "aks") }

  depends_on = [module.network]
}

################################################################################
# Identity AKS
################################################################################

/* resource "azuread_application" "akspe-app" {
  display_name = "akspe-app"
  owners       = [data.azurerm_client_config.current.object_id]

  app_role {
    id              = uuid() # Generate a unique ID for the role
    allowed_member_types = ["User"]
    description          = "Allows the app to read the profile of signed-in users."
    display_name         = "User.Read"
    value                = "User.Read"
  }

  app_role {
    id              = uuid() # Generate a unique ID for the role
    allowed_member_types = ["User"]
    description          = "Allows the app to read all users' full profiles."
    display_name         = "User.Read.All"
    value                = "User.Read.All"
  }

  app_role {
    id              = uuid() # Generate a unique ID for the role
    allowed_member_types = ["User"]
    description          = "Allows the app to read the memberships of all groups."
    display_name         = "GroupMember.Read.All"
    value                = "GroupMember.Read.All"
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph API

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }

    resource_access {
      id   = "98830695-27a2-44f7-8c18-0c3ebc9698f6" # GroupMember.Read.All
      type = "Role"
    }

    resource_access {
      id   = "64a6cdd6-aab1-4aaf-94b8-3cc8405e90d0" # email
      type = "Scope"
    }

    resource_access {
      id   = "7427e0e9-2fba-42fe-b0c0-848c9e6a8182" # offline_access
      type = "Scope"
    }

    resource_access {
      id = "e383f46e-2787-4529-855e-0e479a3ffac0" # mail.send
      type = "Scope"
    }

    resource_access {
      id   = "37f7f235-527c-4136-accd-4a02d197296e" # openid
      type = "Scope"
    }
  }
}

# Define the service principal
resource "azuread_service_principal" "akspe-app-sp" {
  client_id = azuread_application.akspe-app.application_id
}

# Define the service principal password
resource "azuread_service_principal_password" "akspe-sp-password" {
  service_principal_id = azuread_service_principal.akspe-app-sp.id
  end_date             = "2099-01-01T00:00:00Z"
} */

################################################################################
# Workload Identity: Module
################################################################################

resource "azurerm_user_assigned_identity" "akspe" {
  name                = "akspe"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_role_assignment" "akspe_role_assignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.akspe.principal_id
}

resource "azurerm_federated_identity_credential" "crossplane" {
  count               = var.infrastructure_provider == "crossplane" ? 1 : 0
  depends_on          = [module.aks]
  name                = "crossplane-provider-azure"
  resource_group_name = azurerm_resource_group.this.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.akspe.id
  subject             = "system:serviceaccount:crossplane-system:azure-provider"
}

resource "azurerm_federated_identity_credential" "service_operator" {
  count               = var.infrastructure_provider == "capz" ? 1 : 0
  depends_on          = [module.aks]
  name                = "serviceoperator"
  resource_group_name = azurerm_resource_group.this.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.akspe.id
  subject             = "system:serviceaccount:azure-infrastructure-system:azureserviceoperator-default"
}

################################################################################
# GitOps Bridge: Private ssh keys for git
################################################################################
resource "kubernetes_namespace" "argocd_nammespace" {
  depends_on = [module.aks]
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_secret" "git_secrets" {
  depends_on = [kubernetes_namespace.argocd_nammespace]
  for_each = {
    git-addons = {
      type = "git"
      url  = var.gitops_addons_org
      # sshPrivateKey = file(pathexpand(var.git_private_ssh_key))
    }
  }
  metadata {
    name      = each.key
    namespace = kubernetes_namespace.argocd_nammespace.metadata[0].name
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }
  data = each.value
}


################################################################################
# GitOps Bridge: Bootstrap
################################################################################
module "gitops_bridge_bootstrap" {
  depends_on = [module.aks]
  source     = "gitops-bridge-dev/gitops-bridge/helm"

  cluster = {
    cluster_name = module.aks.aks_name
    environment  = local.environment
    metadata = merge(local.cluster_metadata,
      {
        kubelet_identity_client_id = module.aks.kubelet_identity[0].client_id
        subscription_id            = data.azurerm_subscription.current.subscription_id
        tenant_id                  = data.azurerm_subscription.current.tenant_id
    })
    addons = local.addons
  }
  apps = local.argocd_apps
  argocd = {
    namespace     = local.argocd_namespace
    chart_version = var.addons_versions[0].argocd_chart_version
  }
}
