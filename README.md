# Workhorse Platform Environment

> A cloud-native platform engineering environment demonstrating production-style infrastructure, GitOps application delivery, observability, security, incident response, and operational excellence practices on AWS.

---

## 📚 Contents

- 🚧 Planned

---

# 🧭 Project Overview

Workhorse is a hands-on platform engineering lab designed to model how modern cloud infrastructure is built, operated, secured, and continuously improved.

The repository demonstrates:

- AWS infrastructure as code using Terraform
- Kubernetes workloads running on Amazon EKS
- GitOps application delivery using Argo CD
- Automated CI/CD workflows
- Observability and monitoring practices
- Incident response procedures
- Security and governance controls
- Multi-environment platform design

Rather than focusing on a single application, this lab focuses on the platform itself: the systems, tooling, processes, and operational practices required to run reliable cloud-native workloads at scale.

## What This Demonstrates

As an infrastructure and operations leader, this lab serves as a reference architecture illustrating how modern platform teams:

- Provision cloud infrastructure
- Deliver applications safely
- Observe system health
- Respond to incidents
- Secure workloads and data
- Scale environments consistently
- Automate platform operations

---

# 🏗 Macro Architecture Diagram

The diagram below represents the high-level architecture of the Workhorse platform.

<img width="1409" height="931" alt="workhorse-macro-architecture drawio" src="https://github.com/user-attachments/assets/172b783f-382e-420b-8ac3-923d53e8820c" />

See other diagrams within `documentation/Diagrams`

## Architecture Highlights

The platform consists of:

- End users accessing workloads
- AWS networking and managed services
- Amazon EKS clusters
- GitHub repositories
- GitHub Actions CI/CD pipelines
- Argo CD GitOps deployment workflows
- Container registry integration
- Monitoring and observability systems
- Kubernetes-hosted applications

The architecture intentionally illustrates boundaries between:

- Users
- External dependencies
- AWS-managed services
- Kubernetes workloads
- Platform services

---

# 🖥️  App Demonstration

## 🧩 What This Application Is

Emojivoto is a small, cloud‑native, microservices demo application originally built by Buoyant (the creators of Linkerd). It’s designed to showcase service‑mesh behavior, distributed systems patterns, and modern Kubernetes‑native architecture. The app itself is a playful voting system where users vote for their favorite emoji, but under the hood it models a realistic multi‑tier system with several independently deployable services.

Application landing page displaying voting options:
<img width="1905" height="958" alt="Screenshot 2026-08-07 at 6 16 05 PM" src="https://github.com/user-attachments/assets/3793c9c3-e7fb-4c5b-81c5-168ea863e6bc" />

The page user's are shown after their vote is cast:
<img width="1903" height="960" alt="Screenshot 2026-08-07 at 6 16 15 PM" src="https://github.com/user-attachments/assets/74112190-65c8-40bc-843c-75b9b51b7cf2" />

The voting leaderboard page:
<img width="1907" height="958" alt="Screenshot 2026-08-07 at 6 16 28 PM" src="https://github.com/user-attachments/assets/9b8edea8-233d-4f7f-a520-3c1ab2767cc9" />

## App Traffic Flow

<img width="1572" height="916" alt="emojivoto_traffic_flow drawio" src="https://github.com/user-attachments/assets/247d12aa-30c8-48d5-9416-c0b4f621931d" />

## Why I Chose Emojivoto

I chose Emojivoto for this lab project because it provides a compact, production-style environment that lets me demonstrate real SRE and platform engineering skills.

Key reasons:

- **Multi-tier architecture**  
  The app is made up of several services that communicate over HTTP and gRPC. This lets me showcase Kubernetes deployment patterns, service communication, and how to manage a multi-service application.

- **Built-in Prometheus `/metrics` endpoint**  
  Each service exposes a Prometheus-compatible `/metrics` endpoint out of the box. This made it ideal for integrating with an observability stack (Prometheus, Grafana, etc.) without needing to instrument the code myself.

- **Lightweight but realistic**  
  The app is small enough to deploy quickly, but structured enough to model real operational concerns like service dependencies, latency, and monitoring.

- **Open source**  
  Emojivoto is open source and actively used in the Linkerd ecosystem, following modern cloud-native best practices.

---

## What I Built

To use Emojivoto in this lab, I didn’t just deploy the upstream images—I built and hosted my own.

- **Custom container images**  
  I cloned the Emojivoto repository, built the container images for each service, and published them to my GitHub Container Registry. This demonstrates control over the build pipeline and image lifecycle.

- **Kubernetes deployment**  
  I deployed the application to Kubernetes using declarative manifests, showing how to run a multi-service workload in a cluster.

- **Observability integration**  
  Using the built-in `/metrics` endpoints, I wired the application into a Prometheus-based monitoring stack to collect and visualize metrics for the different services.

---

## Why This Matters for My Lab

This project gives me a concrete way to demonstrate:

- Kubernetes orchestration  
- Container image build and registry usage  
- Multi-tier, microservices architecture  
- Metrics and observability using Prometheus  

Emojivoto is a simple app, but it provides a realistic platform to showcase cloud-native and SRE-oriented engineering practices.

---

# 📑 Artifacts

The repository contains architectural diagrams, workflows, and operational documentation used throughout the platform.

## 🖥 EKS Architecture

Illustrates:

- EKS control plane
- Managed node groups
- System namespaces
- Application namespaces
- AWS Load Balancer Controller
- VPC CNI networking
- Service and pod networking
- Observability stack
- Application workloads

### Why It Exists

Provides a detailed representation of workload placement, networking, communication flows, and operational dependencies within the Kubernetes platform.

---

## 🚀 CI/CD Pipeline Architecture

Illustrates the complete delivery lifecycle:

<img width="1633" height="980" alt="workhorse-cicd-pipeline-architecture drawio" src="https://github.com/user-attachments/assets/2421910e-f5fe-4376-9552-79f3d9615378" />

### Included Components

- GitHub Actions
- Terraform validation
- YAML linting
- Kubernetes validation
- Security scanning
- GitOps deployment workflows
- Deployment verification

### Why It Exists

Demonstrates how code safely progresses from commit to production through a repeatable and auditable automation pipeline.

---

## 📖 Platform Documentation

Supporting documentation covers:

- [Design Decisions Documentation](documentation/Architecture,%20Design%20&%20Reliability/DesignDecisions.md)
- Infrastructure designs
- Security decisions
- Deployment strategies
- Monitoring standards
- Networking models
- Operational workflows

### Why It Exists

Documents engineering decisions and provides context behind architectural choices.

### Detailed Architecture Diagram

<img width="2432" height="1833" alt="workhorse-eks-kubernetes-architecture-pod-networking drawio" src="https://github.com/user-attachments/assets/66eadd23-d4d5-40b3-8809-bff6db493146" />

---

# 🛠 Technology Stack

This lab intentionally focuses on technologies commonly found in modern cloud-native environments.

## Cloud Platform

- AWS

## Infrastructure as Code

- Terraform

## Container Platform

- Amazon EKS
- Kubernetes

## GitOps

- Argo CD

## Source Control

- GitHub

## CI

- GitHub Actions

## Observability

- Prometheus
- Grafana
- Loki
- CloudWatch

## Security

- AWS IAM
- IAM Roles for Service Accounts / Pod Identity
- Security Scanning
- Least Privilege Access Controls

---

# 📂 Repository Layout

```
├── documentation
│ ├── Diagrams
│ ├── Environment Setup, Maintenence & Upgrades
│ ├── Planning
│ ├── Reliability
│ ├── Runbooks
│ └── SOPs
└── workhorse
    ├── gitops
    │ ├── addons
    │ │ ├── alloy
    │ │ ├── cert-manager
    │ │ ├── ingress-nginx
    │ │ ├── kube-prometheus-stack
    │ │ ├── loki
    │ │ ├── sealed-secrets
    │ │ └── yace
    │ ├── cluster
    │ │ ├── dev
    │ │ │ └── root
    │ │ │     └── app-of-apps.yaml
    │ │ ├── prod
    │ │ │ └── root
    │ │ │     └── app-of-apps.yaml
    │ │ └── staging
    │ │     └── root
    │ │         └── app-of-apps.yaml
    │ ├── emojivoto
    │ │ ├── base
    │ │ │ ├── deployments
    │ │ │ └── services
    │ │ ├── monitoring
    │ │ │ ├── base
    │ │ │ └── overlays
    │ │ └── overlays
    └── terraform
        ├── envs
        │ ├── prod
        │ └── staging
        ├── modules
        │ ├── eks
        │ ├── lambda-promtail
        │ └── vpc
        └── shared

```

> Repository structure evolves as additional services, capabilities, and experiments are introduced.

---

# 🎯 Case Studies

## 🚧 Planned

---

## 🚨 Incident Response Workflow

Documents the operational process used to handle service incidents.

### Covers

<img width="642" height="1642" alt="incident_responsework_flow drawio" src="https://github.com/user-attachments/assets/c59d13f7-9bed-4359-a51c-bd9534088b94" />

### Why It Exists

Demonstrates operational maturity and structured response procedures designed to minimize outage impact and reduce mean time to recovery (MTTR).

---

# 📈 Platform Maturity Model

| Capability | Status |
|------------|---------|
| AWS Infrastructure as Code | ✅ Implemented |
| Amazon EKS Platform | ✅ Implemented |
| GitHub Actions CI/CD | ✅ Implemented |
| Argo CD GitOps | ✅ Implemented |
| Prometheus Monitoring | ✅ Implemented |
| Grafana Visualization | ✅ Implemented |
| Loki Log Aggregation | ✅ Implemented |
| Incident Response Framework | ✅ Implemented |
| Multi-Environment Strategy | ✅ Implemented |
| Network Policy Enforcement | 🚧 Planned |
| Disaster Recovery Exercises | 🚧 Planned |
| Cost Optimization Framework | 🚧 Planned |

---

# 🔮 Future Improvements

Planned areas of exploration include:

- Advanced policy enforcement
- Progressive delivery strategies
- Cost optimization initiatives
- Disaster recovery testing
- Platform resiliency testing
- Enhanced security controls
- Automated compliance validation
- Multi-cluster experimentation
- Improved observability capabilities

---
