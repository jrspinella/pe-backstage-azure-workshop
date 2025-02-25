
################################################################################
# Resource Group: Resource
################################################################################
resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = local.location
  tags     = var.tags
}

################################################################################
# Postgres: Module
################################################################################
resource "azurerm_postgresql_flexible_server" "backstagedbserver" {
  name                          = "backstage-postgresql-server"
  location                      = local.location
  public_network_access_enabled = true
  administrator_password        = var.postgres_password
  resource_group_name           = azurerm_resource_group.this.name
  administrator_login           = "psqladminun"
  sku_name                      = "GP_Standard_D4s_v3"
  version                       = "12"
  zone                          = 1
}

# Define the PostgreSQL database
resource "azurerm_postgresql_flexible_server_database" "backstage_plugin_catalog" {
  name      = "backstage_plugin_catalog"
  server_id = azurerm_postgresql_flexible_server.backstagedbserver.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "AllowAll"
  server_id        = azurerm_postgresql_flexible_server.backstagedbserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

################################################################################
# Identity: Module
################################################################################

resource "azuread_application" "backstage-app" {
  display_name = "Backstage"

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


# Define the OAuth2 permissions (redirect URIs)
resource "azuread_application_redirect_uris" "backstage_redirect_uri" {
  application_id = "/applications/${azuread_application.backstage-app.object_id}"
  type                  = "Web"
  redirect_uris         = ["https://${azurerm_public_ip.backstage_public_ip.ip_address}/api/auth/microsoft/handler/frame"]
}
# Define the service principal
resource "azuread_service_principal" "backstage-app-sp" {
  client_id = azuread_application.backstage-app.application_id
}

# Define the service principal password
resource "azuread_service_principal_password" "backstage-sp-password" {
  service_principal_id = azuread_service_principal.backstage-app-sp.id
  end_date             = "2099-01-01T00:00:00Z"
}

resource "null_resource" "ascii_art" {
  depends_on = [ azuread_service_principal_password.backstage-sp-password ]
  provisioner "local-exec" {
    command = <<EOT
echo "    _      _     ______  _____   _______ "
echo "   / \\   | |   |  ____||  __ \\|__   __|"
echo "  / _ \\  | |   | |__   | |__) |   | |   "
echo " / ___ \\ | |   |  __|  |  _  /    | |   "
echo "/_/   \\_\|_|___| |____ | | \\\    | |   "
echo "        \\_\\_____|______||_| \_\  |_|   "
echo ""
echo ""
echo "Please grant admin consent on app registration now to avoid waiting for the 1 hour schedule post backstage chart deployment."
echo "This can be done through the Azure portal at the following location: Entra - App registrations - Backstage - API Permissions - <click> Grant admin consent"
echo " This can also be done using the CLI with the following command: az ad app permission admin-consent --id <ApplicationId>"
EOT
  }
}

################################################################################
# AKS: Public IP for predictable backstage service & redirect URI
################################################################################

resource "azurerm_public_ip" "backstage_public_ip" {
  name                = "backstage-public-ip"
  location            = azurerm_resource_group.this.location
  resource_group_name = var.aks_node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

################################################################################
# Backstage: Service Account & Secret
################################################################################
resource "kubernetes_namespace" "backstage_namespace" {
  metadata {
    name = "backstage"
  }
}
resource "kubernetes_service_account" "backstage_service_account" {
  depends_on = [ kubernetes_namespace.backstage_namespace ]
  metadata {
    name      = "backstage-service-account"
    namespace = "backstage"    
  }  
}

resource "kubernetes_role" "backstage_pod_reader" {
  depends_on = [ kubernetes_service_account.backstage_service_account ]
  metadata {
    name      = "backstage-pod-reader"
    namespace = "backstage"
  }

  rule {
    api_groups = [""]
    resources  = [
      "pods",
      "services",
      "replicationcontrollers",
      "persistentvolumeclaims",
      "configmaps",
      "secrets",
      "events",
      "pods/log",
      "pods/status",
    ]
    verbs = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "backstage_role_binding" {
  depends_on = [kubernetes_role.backstage_pod_reader]
  metadata {
    name      = "backstage-role-binding"
    namespace = "backstage"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.backstage_pod_reader.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.backstage_service_account.metadata[0].name
    namespace = kubernetes_service_account.backstage_service_account.metadata[0].namespace
  }
}

resource "kubernetes_secret" "backstage_service_account_secret" {
  depends_on = [ kubernetes_service_account.backstage_service_account ]
  metadata {
      annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.backstage_service_account.metadata[0].name
    }
    name      = "backstage-service-account-secret"
    namespace = kubernetes_service_account.backstage_service_account.metadata[0].namespace
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}

################################################################################
# Backstage: Bootstrap
################################################################################

resource "kubernetes_secret" "tls_secret" {
  count      = local.helm_release ? 1 : 0
  depends_on = [kubernetes_namespace.backstage_namespace]

  metadata {
    name      = "my-tls-secret"
    namespace = kubernetes_namespace.backstage_namespace.metadata[0].name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = file("tls.crt")  # Adjust the path accordingly
    "tls.key" = file("tls.key")  # Adjust the path accordingly
  }
}

resource "helm_release" "backstage" {
  count      = local.helm_release ? 1 : 0
  depends_on = [ kubernetes_secret.tls_secret ]
  name       = "backstage"
  chart      = "pe-backstage-azure-workshop-1/backstage/backstagechart"
  version    = "0.1.0"

  set {
    name  = "image.repository"
    value = "backstageacrjrs.azurecr.us/backstage"
  }
    set {
    name  = "image.tag"
    value = "v2"
  }
    set {
    name  = "env.K8S_CLUSTER_NAME"
    value = var.aks_name
  }

      set {
    name  = "env.K8S_CLUSTER_URL"
    value = "https://pe-beoqtio7.hcp.usgovvirginia.cx.aks.containerservice.azure.us:443"
  }

  set {
    name  = "env.K8S_SERVICE_ACCOUNT_TOKEN"
    value = kubernetes_secret.backstage_service_account_secret.data.token
  }

    set {
    name  = "env.GITHUB_TOKEN"
    value = local.github_token
  }

  set {
    name = "env.GITOPS_REPO"
    value = local.gitops_addons_url
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
    value = var.aks_node_resource_group
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-ipv4"
    value = azurerm_public_ip.backstage_public_ip.ip_address
  }
  set {
    name  = "image.tag"
    value = "v1"
  }

  set {
    name  = "env.BASE_URL"
    value = "https://${azurerm_public_ip.backstage_public_ip.ip_address}"
  }

  set {
    name  = "env.POSTGRES_HOST"
    value = azurerm_postgresql_flexible_server.backstagedbserver.fqdn
  }

  set {
    name  = "env.POSTGRES_PORT"
    value = "5432"
  }

  set {
    name  = "env.POSTGRES_USER"
    value = azurerm_postgresql_flexible_server.backstagedbserver.administrator_login
  }

  set {
    name  = "env.POSTGRES_PASSWORD"
    value = azurerm_postgresql_flexible_server.backstagedbserver.administrator_password
  }

  set {
    name  = "env.POSTGRES_DB"
    value = azurerm_postgresql_flexible_server_database.backstage_plugin_catalog.name
  }

  set {
    name  = "env.AZURE_CLIENT_ID"
    value = azuread_application.backstage-app.client_id
  }

  set {
    name  = "env.AZURE_CLIENT_SECRET"
    value = azuread_service_principal_password.backstage-sp-password.value
  }

  set {
    name  = "env.AZURE_TENANT_ID"
    value = data.azurerm_client_config.current.tenant_id
  }
    set {
    name  = "podAnnotations.backstage\\.io/kubernetes-id"
    value = "${var.aks_name}-component"
  }
  
  set {
    name  = "labels.kubernetesId"
    value = "${var.aks_name}-component"
  }
}