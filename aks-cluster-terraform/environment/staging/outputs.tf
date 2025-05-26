output "kube_config" {
  description = "Raw Kubernetes config for the AKS cluster"
  value       = module.aks.kube_config
  sensitive   = true
}

output "cluster_name" {
  description = "AKS cluster name"
  value       = module.aks.aks_name
}