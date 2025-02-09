variable "resource_group_name" {
  description = "Specifies the name of the resource group."
  default     = "aks-gitops"
  type        = string
}

variable "github_token" {
  description = "Specifies the GitHub token for the GitHub repository."
  type        = string
  default     = ""
  
}

variable "location" {
  description = "Specifies the the location for the Azure resources."
  type        = string
  default     = "eastus2"
}
