# Diagrams to be created TBD

* System Architecture
  - Macro-level: Shows User, AWS, External Dependencies (Github and Container Repo), Ingress, K8s Nodes, ArgoCD Deployment
  - High level, no need for detail
* CI/CD Pipeline
  - how code moves from Commit > Build > Test > Deploy > Verify
* K8s Architecture
  - shows node groups, namespaces, ingress auto scaling, networking, service mesh, and observability
  - show control plane and data plane
* incident response workflow
  - will specify where to look to identify potential issues first, where to look for monitoring and observability dashboard as well as logging. Where to see cloud, watch logs, node logs. Where to get these logs if grafama is down, and further if EKS is down