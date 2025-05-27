# Azure AKS Terraform Project

## Project Directory Tree

```
aks-cluster-terraform/
├── provider.tf                # Configures the Azure provider for Terraform
├── README.md                  # Project documentation and usage instructions
├── environment/
│   └── staging/
│       ├── backend.tf         # Remote backend configuration for Terraform state
│       ├── main.tf            # Main entrypoint for staging environment resources
│       ├── outputs.tf         # Outputs for kubeconfig and cluster name
│       ├── variables.tf       # Variable definitions for the staging environment
│       ├── provider.tf        # Provider Plugin Configuration
│       └── variables.tfvars   # Example variable values for staging
├── modules/
│   ├── aks/
│   │   ├── main.tf            # AKS cluster resource definition
│   │   ├── outputs.tf         # Outputs for AKS module (e.g., kubeconfig)
│   │   └── variables.tf       # Input variables for AKS module
│   ├── networking/
│   │   ├── main.tf            # VNet and subnet resource definitions
│   │   ├── outputs.tf         # Outputs for networking module (e.g., subnet ID)
│   │   └── variables.tf       # Input variables for networking module
│   └── resource_group/
│       ├── main.tf            # Resource group resource definition
│       ├── outputs.tf         # Outputs for resource group module
│       └── variables.tf       # Input variables for resource group module
```

---

## Usage

1. Initialize: `terraform init`
2. Plan: `terraform plan`
3. Apply: `terraform apply` (Run from eks-cluster-terraform/environment/staging/)

## Azure Authentication for Terraform

To provision AKS, Terraform needs Azure credentials i.e., Service Principal (Recommended for CI/CD)

Export these environment variables before running Terraform (Can be fetched as Jenkins Credentals for security reasons):

```bash
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<subscription>"
export ARM_TENANT_ID="<tenant>"
```

You can create a Service Principal with:

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

---

## Backend State Storage

Current terraform modules does **not** automatically create the backend storage resources. You must provision the resource group, storage account, and container for state before using remote state.

---

## Outputs

- `kube_config`: Raw Kubernetes config for the AKS cluster (use to connect with kubectl)
- `aks_cluster_name`: Name of the AKS cluster

---
