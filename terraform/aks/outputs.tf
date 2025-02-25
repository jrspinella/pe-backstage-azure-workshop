
output "aks_name" {
  value = module.aks.aks_name
}

output "aks_url" {
  value = module.aks.cluster_fqdn
}

output "aks_node_resource_group" {
  value = module.aks.node_resource_group
}

output "kubeconfig_path" {
  value = local_file.kubeconfig.filename
}

output "gitops_addons_url" {
  value = "${var.gitops_addons_org}/${var.gitops_addons_repo}"
}

output "gitops_addons_basepath" {
  value = var.gitops_addons_basepath
}