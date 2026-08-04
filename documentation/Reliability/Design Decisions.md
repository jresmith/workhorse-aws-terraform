## Design decisions

* Why did you chose
  - EKS over k3s/minikube
  - ArgoCD + GitOps over kubectl apply
  - Prometheus + Loki over ELK or Datadog
  - Terraform instead of Cloudformation
* Each decision Including
  - The Problem
  - Options considered
  - Tradeoffs
  - FinalChoice
  - Why it fits principles (simplicity, reliability, cost, observability)


## Misc Documentation

* Talk about how I will be storing some credentials for Production in GitLab (since this is just ) but acknowledge that should be using a Centralised External Secret Store like HashiCorp Vault or AWS Secrets Manager
* Increarse pod replicas (as part of SLI/SLO resiliancy plan)
* How to upgrade EKS cluster (note that EKS is only supported for 14 months)
* Deployment plan for App - how to roll out a new version of the app and how to increase capacity (noting that we should be testing at three times the peak expected capacity)

## Misc Documentation 2

* Using Pod Identity because IRSA is becoming legacy
* Still need IRSA for AWS Load Balancer Controller service account because they don't support Pod Identity yet
