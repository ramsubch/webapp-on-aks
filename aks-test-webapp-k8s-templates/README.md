# Kubernetes Resource Templates for aks-test-webapp

This directory contains Kubernetes manifests for deploying the `aks-test-webapp` on Azure Kubernetes Service (AKS). The templates are designed with security, robustness, and resiliency in mind.

---

## Security Features

- **Least Privilege Container Security**: The deployment uses a `securityContext` to drop all Linux capabilities, disallow privilege escalation, enforce running as a non-root user, and set a read-only root filesystem.
- **Seccomp Profile**: The container uses the `RuntimeDefault` seccomp profile, reducing the attack surface by restricting system calls.
- **Secrets Management**: Example secret and configMap mounts are provided, allowing sensitive data to be injected securely as files or environment variables.
- **Image Pull Secrets**: Supports pulling images from private registries (e.g., Azure Container Registry) using Kubernetes secrets.
- **Network Policies**: Includes `network-policy-default-deny.yaml` to deny all traffic by default, and `network-policy-allow.yaml` to explicitly allow required traffic, enforcing zero-trust networking principles.

---

## Robustness & Resiliency Features

- **Pod Anti-Affinity**: Ensures that replicas are scheduled on different nodes, improving availability and fault tolerance.
- **Pod Disruption Budget (PDB)**: The `pdb.yaml` ensures a minimum number of pods are always available during voluntary disruptions (e.g., node upgrades).
- **Horizontal Pod Autoscaler (HPA)**: The `hpa.yaml` automatically scales the number of pods based on CPU/memory usage, ensuring the app can handle varying loads.
- **Liveness & Readiness Probes**: Health checks are defined to ensure only healthy pods receive traffic and to enable automatic recovery from failures.
- **Resource Requests & Limits**: Each container specifies CPU and memory requests/limits to ensure fair scheduling and prevent resource starvation.
- **Tolerations**: Example tolerations are provided to allow scheduling on specific nodes if needed.

---

## Templates Overview

```
aks-test-webapp-k8s-templates/
├── deployment.yaml                  # Main deployment, security context, probes, affinity, volumes
├── service.yaml                     # Exposes the app as a ClusterIP/LoadBalancer service
├── ingress.yaml                     # Ingress resource for HTTP routing
├── configmap.yaml                   # App configuration (e.g., NGINX config)
├── hpa.yaml                         # Horizontal Pod Autoscaler
├── pdb.yaml                         # Pod Disruption Budget
├── network-policy-default-deny.yaml # Deny all traffic by default
├── network-policy-allow.yaml        # Allow required traffic
```

---

## Architecture Diagram

![Kubernetes Design](doc/images/k8s-design.drawio.svg)

---

## Design considerations

- Principle of least privilege for containers
  - The deployment enforces a strict `securityContext` that drops all Linux capabilities, disables privilege escalation, runs as a non-root user, and uses a read-only root filesystem. This minimizes the risk of container breakout and privilege escalation attacks.
- Secure secret/config management
  - Secrets and configuration data are injected using Kubernetes Secrets and ConfigMaps, mounted as files or environment variables. This avoids hardcoding sensitive data in images or manifests and supports secure updates and rotation.
- Autoscaling and self-healing
  - The Horizontal Pod Autoscaler (HPA) automatically adjusts the number of pod replicas based on resource usage, ensuring the application can handle varying loads. Liveness and readiness probes enable Kubernetes to detect and recover from unhealthy pods automatically.
- Network segmentation and zero-trust
  - The `network-policy-default-deny.yaml` enforces a default-deny posture for all ingress and egress traffic to pods, ensuring that no network communication is allowed unless explicitly permitted. The `network-policy-allow.yaml` selectively allows only the required traffic, minimizing the attack surface and lateral movement within the cluster. By segmenting network access at the pod level, the deployment ensures that even if one pod is compromised, it cannot freely communicate with others, thus containing potential breaches and improving overall security posture.
- Resilient scheduling and disruption handling
  - Pod anti-affinity rules ensure that replicas are scheduled on different nodes, improving availability and fault tolerance. The Pod Disruption Budget (PDB) ensures a minimum number of pods remain available during voluntary disruptions, such as node upgrades or maintenance.
- Ingress-based exposure (vs. direct LoadBalancer)
  - The application is exposed using an Ingress resource rather than a direct LoadBalancer public IP. This approach enables the use of cloud-native TLS termination (e.g., Azure Application Gateway or NGINX Ingress Controller with Azure-managed certificates), providing secure HTTPS endpoints without managing certificates inside the cluster. Additionally, Ingress allows routing multiple endpoints or services based on URL path prefixes (e.g., `/api`, `/web`), supporting more advanced traffic management and consolidation of public entry points.
- Namespaces are intentionally not specfied in the templates as it can be specified when deploying templates, thus making generic
- Helm can be used to package and make the configuration configurable using values.yaml and jinja templating. It has also advanced features of adding pre and post LCM hooks for advanced operations, but not considered in the scope of this

---

For more details, see the comments in each manifest and the architecture diagram above.

