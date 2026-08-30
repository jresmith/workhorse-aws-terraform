# Workhorse Platform Environment

## 👨‍💻 Developed by __jresmith__

> A cloud-native platform engineering environment demonstrating production-style infrastructure, GitOps application delivery, observability, security, incident response, and operational excellence practices on AWS.

---

## 📚 README Contents

- [Project Overview](https://github.com/jresmith/workhorse-aws-terraform/tree/main#-project-overview)
- [Macro Architecture Diagram](https://github.com/jresmith/workhorse-aws-terraform/tree/main#-macro-architecture-diagram)
- [Platform & Reliability Documentation](https://github.com/jresmith/workhorse-aws-terraform/blob/main/README.md#-platform--reliability-documentation)
- [App Demonstration](https://github.com/jresmith/workhorse-aws-terraform/tree/main#%EF%B8%8F--app-demonstration)
- [Artifacts](https://github.com/jresmith/workhorse-aws-terraform/tree/main#-artifacts)
- [Technology Stack](https://github.com/jresmith/workhorse-aws-terraform/tree/main#-technology-stack)
- [Repository Layout](https://github.com/jresmith/workhorse-aws-terraform/tree/main#-repository-layout)
- [Incident Response Workflow](https://github.com/jresmith/workhorse-aws-terraform/tree/main#-incident-response-workflow)
- [Platform Maturity Model](https://github.com/jresmith/workhorse-aws-terraform/tree/main#-platform-maturity-model)
- [Future Improvements](https://github.com/jresmith/workhorse-aws-terraform/tree/main#-future-improvements)
---

# 🧭 Project Overview

Workhorse is a hands-on platform engineering lab I designed and built to model how modern cloud infrastructure is provisioned, operated, secured, and continuously improved.

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

## 🧠 Key Skills Demonstrated

- **Infrastructure as Code** — Terraform modules, multi‑environment deployments  
- **Kubernetes Platform Engineering** — EKS, networking, ingress, pod identity  
- **GitOps Delivery** — Argo CD app‑of‑apps, environment separation  
- **CI/CD Automation** — GitHub Actions validation, scanning, deployment workflows  
- **Observability** — Prometheus, Grafana, Loki, YACE, CloudWatch  
- **Reliability Engineering** — SLIs/SLOs, monitoring strategy, incident response  
- **Security & Governance** — IAM, cert‑manager, sealed secrets, least‑privilege access  
- **Operational Excellence** — SOPs, runbooks, postmortems, architecture documentation  


## 🧭 How to Use This Repository

- Review architecture diagrams in `documentation/`  
- Explore Terraform IaC in `workhorse/terraform/`  
- Inspect GitOps and Application configuration in `workhorse/gitops/` 

---

# Video Demonstration

<img width="1906" height="917" alt="Screenshot 2026-08-29 at 7 32 22 PM" src="https://github.com/user-attachments/assets/967cc729-2464-4c65-99f6-0781d37fcd10" />

📺 [Workhorse: EKS Platform Demo](https://youtu.be/e0XvYE-SUSs?si=0eZRm00hVfOkMNkB)

---
# 🏗 Macro Architecture Diagram

The diagram below represents the high-level architecture of the Workhorse platform.

<img width="1409" height="931" alt="workhorse-macro-architecture drawio" src="https://github.com/user-attachments/assets/172b783f-382e-420b-8ac3-923d53e8820c" />

This architecture models a realistic multi‑environment AWS/EKS platform with GitOps delivery, observability, and production‑grade networking and security boundaries.

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

## Why This Platform Matters

- Shows end‑to‑end platform engineering capability
- Demonstrates production‑grade IaC, GitOps, observability, and operational workflows
- Models real SRE practices including SLIs/SLOs, incident response, and reliability design
- Provides a multi‑environment AWS/EKS setup similar to what modern platform teams run

## 📖 Platform & Reliability Documentation

Supporting documentation covers:

- [Design Decisions](documentation/Architecture,%20Design%20&%20Reliability/DesignDecisions.md)
- [Monitoring Strategy](https://github.com/jresmith/workhorse-aws-terraform/blob/main/documentation/Architecture%2C%20Design%20%26%20Reliability/Monitoring%20Strategy.md)
- [SLIs, SLOs & SLAs](documentation/Architecture%2C%20Design%20%26%20Reliability/SLIs%2C%20SLOs%20%26%20SLAs.md)
- [SOPs](documentation/Environment%20Setup%2C%20Maintenence%20%26%20Upgrades/SOPs)
- [Runbooks](documentation/Environment%20Setup%2C%20Maintenence%20%26%20Upgrades/Runbooks)
- [Case Studies](documentation/Architecture%2C%20Design%20%26%20Reliability/Case%20Studies)
- [Post Mortems](documentation/Environment%20Setup%2C%20Maintenence%20%26%20Upgrades/Post%20Mortems)
- [Environment Setup Instructions](documentation/Environment%20Setup%2C%20Maintenence%20%26%20Upgrades/Environment%20Setup%20Instructions.md)

These documents demonstrate operational maturity and show how I approach reliability engineering, platform design, and production readiness.

---

# 🖥️  App Demonstration

## 🧩 What This Application Is

Emojivoto is a small, cloud‑native, microservices demo application originally built by Buoyant (the creators of Linkerd). It’s designed to showcase service‑mesh behavior, distributed systems patterns, and modern Kubernetes‑native architecture. The app itself is a playful voting system where users vote for their favorite emoji, but under the hood it models a realistic multi‑tier system with several independently deployable services.

Application Landing page displaying voting options:
<img width="1905" height="958" alt="Screenshot 2026-08-07 at 6 16 05 PM" src="https://github.com/user-attachments/assets/3793c9c3-e7fb-4c5b-81c5-168ea863e6bc" />

The page users see after casting a votet:
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

These artifacts illustrate how the platform operates, how workloads are deployed, and how reliability is maintained across environments.

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

## 🔎 Observability Dashboards Samples

Full list of Dashboards - [Monitoring & Alerting Strategy](https://github.com/jresmith/workhorse-aws-terraform/blob/main/documentation/Architecture,%20Design%20&%20Reliability/Monitoring%20&%20Alerting%20Strategy.md)

Application Reliability Dashboard:

<img width="1915" height="954" alt="Application Reliability" src="https://github.com/user-attachments/assets/05cdeeed-e1a5-42f8-b444-563a543b432b" />

Kubernetes Global Dashboard:

<img width="1914" height="953" alt="Kubernetes Views Global" src="https://github.com/user-attachments/assets/0f6083a2-b4cd-413f-8d7d-167399bdfb71" />

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

### Detailed Architecture Diagram

<img width="4864" height="3666" alt="workhorse-eks-kubernetes-architecture-pod-networking drawio" src="https://github.com/user-attachments/assets/8d0030bc-c85e-4577-b408-faadaa3a3129" />

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
- YACE
- Alloy
- CloudWatch

## Security

- AWS IAM
- Sealed Secrets
- cert-manager
- IAM Roles for Service Accounts / Pod Identity
- Security Scanning
- Least Privilege Access Controls

---

# 📂 Repository Layout

The layout follows a standard platform‑engineering pattern: Terraform for infrastructure, GitOps for cluster state, and documentation for operational workflows.

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

## 🚨 Incident Response Workflow

Documents the operational process used to handle service incidents.

This workflow models how platform teams coordinate during outages, escalate issues, and restore service quickly.

<img width="642" height="1642" alt="incident_responsework_flow drawio" src="https://github.com/user-attachments/assets/c59d13f7-9bed-4359-a51c-bd9534088b94" />

### Why It Exists

Demonstrates operational maturity and structured response procedures designed to minimize outage impact and reduce mean time to recovery (MTTR).

---

# 🔮 Future Improvements

Planned areas of exploration in the near future include:

- **Calico** CNI and **Network Policy Enforcement** between pods, separating by tiers (Platform, Security & Application)
- Implement **HashiCorp Vault** or **AWS Secrets Manager** to manage Production secrets instead of Bitnami Sealed Secrets
- Implement Cluster Autoscaler using **Karpenter**, utilizing worker nodes across multiple AWS regions
- Implement **LokiRuler** to alert based on logging activity
- Deploy **CloudFront** in front of ALB to serve Application Web UI
- Automated Review & Deployment of IaC changes via Github CI/CD
- Instrument emojo-voto to use **Telemetry** and deploy Tempo to collect **Trace** data
- Platform resiliency testing (**Chaos Engineering**)
- Disaster Recovery documentation
- Cost optimization initiatives

[Full List of Potential Future Improvements](https://github.com/jresmith/workhorse-aws-terraform/blob/main/documentation/Repo%20Development/Future%20Plans.md)

---
