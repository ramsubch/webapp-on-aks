# Azure AKS Terraform Project

## Overview

This project provides a modular Terraform configuration for deploying a scalable and resilient Azure Kubernetes Service (AKS) cluster. The setup follows Azure and Terraform recommended practices, including remote state management, modular code structure, and secure authentication.

---

## Architecture Diagram

![AKS Cluster Setup](doc/images/AKS-Cluster-Setup.drawio.svg)

> **Notes:**
> 1. The focus is on AKS cluster provisioning and its supporting infrastructure.
> 2. Storage backend and Service Principal for Terraform are assumed to be pre-created (see steps below).
> 3. The `tfvars` file is included for reference only; do not check sensitive values into version control.
> 4. ACR (Azure Container Registry) integration is optional; imagePullSecrets can be used for private registry access.
> 5. The diagram may include conceptual elements for clarity that are not directly represented in the Terraform code.

---

## Project Structure

```
aks-cluster-terraform/
├── provider.tf                # Azure provider configuration
├── README.md                  # Project documentation
├── environment/
│   └── staging/
│       ├── backend.tf         # Remote backend configuration for Terraform state
│       ├── main.tf            # Staging environment entrypoint
│       ├── outputs.tf         # Outputs for kubeconfig and cluster name
│       ├── variables.tf       # Variable definitions for staging
│       ├── provider.tf        # Provider plugin configuration (if needed)
│       └── variables.tfvars   # Example variable values for staging
├── modules/
│   ├── aks/
│   │   ├── main.tf            # AKS cluster resource definition
│   │   ├── outputs.tf         # Outputs for AKS module
│   │   └── variables.tf       # Input variables for AKS module
│   ├── networking/
│   │   ├── main.tf            # VNet and subnet resource definitions
│   │   ├── outputs.tf         # Outputs for networking module
│   │   └── variables.tf       # Input variables for networking module
│   └── resource_group/
│       ├── main.tf            # Resource group resource definition
│       ├── outputs.tf         # Outputs for resource group module
│       └── variables.tf       # Input variables for resource group module
```

---

## Getting Started

### 1. Azure Authentication

Terraform requires Azure credentials to provision resources. The recommended approach is to use a Service Principal (suitable for CI/CD):

```bash
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<subscription>"
export ARM_TENANT_ID="<tenant>"
```

Create a Service Principal:

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

Alternatively, you can use Azure CLI authentication (`az login`) for local development.

### 2. Remote State Backend

Remote state is used for collaboration and state locking. You must manually provision the backend resources:

1. Create a resource group (e.g., `tfstate-rg`)
2. Create a storage account in that group
3. Create a blob container (e.g., `tfstate`)

This separation ensures Terraform state is managed independently from the AKS resources.

---

## Usage

1. Initialize: `terraform init`
2. Plan: `terraform plan`
3. Apply: `terraform apply` (from `aks-cluster-terraform/environment/staging/`)

---

## Outputs

- `kube_config`: Raw Kubernetes config for the AKS cluster (for use with `kubectl`)
- `aks_cluster_name`: Name of the AKS cluster

---

## Design Highlights

### Terraform
- Modular structure: separate modules for resource group, networking, and AKS
- Environment-specific configuration under `environment/`
- Remote state and state locking for safe collaboration
- Example `tfvars` for reference (do not commit secrets)

### AKS Cluster
- Configurable default node pool with autoscaling enabled
- Controlled upgrade strategy (no auto-upgrade by default)
- Minimum node count for high availability
- Node pools can be spread across Availability Zones for resiliency
- Support for additional node pools with taints/tolerations for workload separation
- Example: pods with toleration: `app=frontend:NoSchedule` are scheduled only on `nodepool1`, and with toleration `app=backend` on `nodepool2`
- Autoscaling and minimum node count ensure redundancy and self-healing

---

For more details, see the comments in each Terraform file and the architecture diagram above.
