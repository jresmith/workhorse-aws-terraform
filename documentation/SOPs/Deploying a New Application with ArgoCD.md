# SOP: Deploying a New Application with ArgoCD

## Purpose

This document describes the standard process for deploying new applications and cluster add-ons to the Workhorse platform using ArgoCD and Kustomize.

The goal is to ensure all workloads follow a consistent GitOps deployment pattern across Development, Staging, and Production environments.

---

# 1. Determine the Application Type

Before creating any files, determine whether the deployment is an application workload or a cluster add-on.

## Application Workload

Application workloads are user-facing or business applications that form part of the platform.

Examples:

- Emojivoto
- Frontend applications
- APIs
- Background workers
- Internal services

Application workloads must be placed under:

```
workhorse/gitops/
```

---

## Cluster Add-On

Cluster add-ons are infrastructure services that support the Kubernetes cluster itself.

Examples:

- Metrics Server
- ExternalDNS
- AWS Load Balancer Controller
- Prometheus
- Loki
- Alloy
- Sealed Secrets

Cluster add-ons must be placed under:

```
workhorse/gitops/addons/
```

---

# 2. Create the Application Directory Structure

## Application Workloads

Create a directory matching the application name:

```
workhorse/gitops/
└── my-application/
```

Within the application directory, create the following structure:

```
my-application/
├── base/
└── overlays/
    ├── dev/
    ├── staging/
    └── prod/
```

### Base Structure

The `base` directory contains configuration shared across all environments.

Resources should be separated by type and pod/component role.

Example:

```
base/
├── deployments/
│   ├── frontend.yaml
│   └── worker.yaml
├── services/
│   ├── frontend.yaml
│   └── worker.yaml
├── hpa/
│   ├── frontend.yaml
│   └── worker.yaml
└── kustomization.yaml
```

This structure improves maintainability and keeps resources logically separated.

---

## Cluster Add-Ons

For cluster-level services, create the following structure:

```
workhorse/gitops/addons/
└── my-addon/
```

Directory layout:

```
my-addon/
├── base/
└── overlays/
    ├── dev/
    ├── staging/
    └── prod/
```

Cluster add-ons must follow the same Kustomize structure as application workloads.

---

# 3. Configure Kustomize

All deployments within the Workhorse platform must be managed through Kustomize.

Every directory must contain a valid:

```
kustomization.yaml
```

---

## Base Configuration

The base layer contains resources that are common across all environments.

Example:

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - deployments
  - services
  - hpa
```

---

## Overlay Configuration

Environment overlays should reference the shared base configuration.

Example:

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - ../../base
```

Environment-specific customizations should be handled through overlays and patches rather than duplicating manifests.

Examples include:

- Replica counts
- Resource requests and limits
- HPA thresholds
- Environment variables
- Image versions
- DNS configurations

---

# 4. Namespace Configuration

Applications should generally deploy into dedicated namespaces.

Example:

```
emojivoto-dev
emojivoto-staging
emojivoto-prod
```

Namespaces should be managed through GitOps and committed alongside the application configuration wherever practical.

If ArgoCD is responsible for namespace creation, ensure the following sync option is configured:

```
syncOptions:
  - CreateNamespace=true
```

---

# 5. Create the ArgoCD Application

Once the application configuration has been created, the application must be registered with ArgoCD.

Create an ArgoCD Application manifest within the appropriate environment directory:

```
workhorse/gitops/cluster/dev/
workhorse/gitops/cluster/staging/
workhorse/gitops/cluster/prod/
```

Use the standard template below.

```
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-application
  namespace: argocd

spec:
  project: default

  source:
    repoURL: https://github.com/jresmith/workhorse-aws-terraform.git
    targetRevision: main
    path: workhorse/gitops/my-application/overlays/dev

  destination:
    server: https://kubernetes.default.svc
    namespace: my-application-dev

  syncPolicy:
    automated:
      prune: true
      selfHeal: true

    syncOptions:
      - CreateNamespace=true
      - ServerSideApply=true
```

---

# 6. Configure Environment-Specific ArgoCD Applications

Each ArgoCD Application must point to the correct environment overlay.

## Development

```
workhorse/gitops/my-application/overlays/dev
```

## Staging

```
workhorse/gitops/my-application/overlays/staging
```

## Production

```
workhorse/gitops/my-application/overlays/prod
```

This ensures environment-specific configuration is separated while inheriting from the shared base configuration.

---

# 7. Validate the Configuration

Before committing changes, validate all manifests.

## Build Kustomize Output

```
kubectl kustomize workhorse/gitops/my-application/overlays/dev
```

or

```
kustomize build workhorse/gitops/my-application/overlays/dev
```

The build must complete successfully without errors.

---

## Review Generated Resources

Confirm the following:

- Namespace is correct
- Image tags are correct
- Resource requests and limits are defined
- HPA configuration is correct
- Service configuration is correct
- No unexpected resources are generated

---

# 8. Commit and Deploy

Commit and push all changes to Git.

```
git add .
git commit -m "Add my-application"
git push
```

Once changes are merged into the repository, ArgoCD will automatically detect the new application and deploy it according to the configured synchronization policy.

No manual deployment activities should be required.

---

# Required Standards

All applications deployed to the Workhorse platform must comply with the following standards.

## Kustomize

- All deployments must use Kustomize.
- Environment-specific configuration must be implemented through overlays.
- Separate overlays must exist for Dev, Staging, and Production.

## ArgoCD

- All workloads must be deployed through ArgoCD.
- Changes must be made through GitOps workflows only.
- Direct modifications to cluster resources are not permitted.

## Resource Organization

- Deployments must be separated into dedicated deployment directories.
- Services must be separated into dedicated service directories.
- HPA resources must be separated into dedicated HPA directories.
- Pod types should be logically separated where multiple workloads exist.

## Resource Requests

Resource requests are mandatory for all deployments.

At a minimum, every container must define:

```
resources:
  requests:
    cpu: 100m
    memory: 128Mi
```

Appropriate values should be selected based on application requirements.

This is required to:

- Support Horizontal Pod Autoscaling (HPA)
- Improve scheduling decisions
- Prevent resource starvation
- Ensure predictable cluster behavior

## Secrets Management

Secrets must be managed using Bitnami Sealed Secrets.

Raw Kubernetes Secrets must never be committed to Git repositories.

Approved process:

1. Create a standard Kubernetes Secret manifest.
2. Encrypt it using `kubeseal`.
3. Commit only the resulting SealedSecret manifest.

Example:

```
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
```

This ensures sensitive information remains encrypted within source control.

## Horizontal Pod Autoscaling (HPA)

Applications should implement HPA where appropriate.

HPA resources should be stored within the dedicated:

```
base/hpa/
```

directory structure.

HPA is recommended for workloads that:

- Experience variable demand
- Run user-facing services
- Benefit from automatic scaling

---

# Recommended Standards

The following practices are strongly recommended:

- Resource limits on all containers
- Dedicated namespaces per environment
- Multiple replicas for production workloads
- Environment-specific resource tuning through overlays
- Consistent naming conventions across all environments

---

# Summary

When deploying a new workload:

1. Determine whether it is an application or cluster add-on.
2. Create the required Kustomize base and overlay structure.
3. Organize Deployments, Services, and HPA resources into dedicated directories.
4. Configure environment-specific overlays.
5. Register the application with ArgoCD.
6. Validate manifests locally with Kustomize.
7. Use Bitnami Sealed Secrets for all secret management.
8. Ensure resource requests are defined for every Deployment.
9. Commit and push changes to Git.
10. Allow ArgoCD to deploy the application automatically.