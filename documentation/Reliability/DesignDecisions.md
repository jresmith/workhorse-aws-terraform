# Design Decisions

## Purpose
This document explains the architectural decisions, tradeoffs, and ationalebehind the Workhorse platform. It is written to demonstrate engineering maturity, reliability thinking, and the ability to justify technical choices in a real SRE/Platform Engineering environment.

Each section roughly follows the below format:

* Why did you make X decision
* Each decision Including
  - The Problem
  - Options considered
  - Tradeoffs
  - FinalChoice
  - Why it fits principles (simplicity, reliability, cost, observability)

---

## 1. Platform Goals
The platform was designed around five core objectives:

- **Reliability** — predictable behavior under load, failure isolation, and clear SLOs  
- **Scalability** — horizontal scaling, autoscaling, and multi‑AZ readiness  
- **Operational Safety** — GitOps workflows, controlled promotion, and safe production defaults  
- **Observability** — metrics, logs, and actionable alerting tied to SLOs  
- **Cost Efficiency** — maximize reliability and operational value while minimizing infrastructure spend

These goals guided every decision below.

---

# 2. Kubernetes Architecture Decisions

## 2.1 EKS as the Control Plane
**Decision:** Use Amazon EKS instead of self‑managed Kubernetes.

**Rationale:**
- Offloads control plane management and patching  
- Native integration with IAM, VPC CNI, CloudWatch, and ALB Ingress  
- Strong alignment with real-world SRE environments  

**Alternatives considered:**
- Self-managed Kubernetes → rejected due to operational overhead  
- GKE/AKS → rejected to keep Terraform modules AWS‑focused  
- Self-managed Kubernetes using kOps
- Self-managed Kubernetes using kubeadm

**Additional Alternatives considered:**

- Self-managed Kubernetes using kOps
- Self-managed Kubernetes using kubeadm

**Rejected because:**

- Additional operational burden
- Control plane maintenance responsibility
- Upgrade and patch management overhead
- Reduced focus on application and platform engineering objectives

---

## 2.2 Cluster Autoscaling Strategy
**Decision:** Implement **Karpenter** (planned) instead of the legacy Cluster Autoscaler.

**Rationale:**
- Faster provisioning and better bin-packing  
- Native support for Spot + On-Demand blends  
- Simplifies node group management  

**Tradeoff:**
- Requires deeper IAM and EC2 configuration  
- More moving parts → higher initial complexity  

---

## 2.3 Horizontal Pod Autoscaling (HPA)
**Decision:** [TBD]

**Rationale:**
- [TBD]

---

## 2.4 Networking & IP Strategy
**Decision:** Use AWS VPC CNI with **warm ENIs** and **prefix delegation** (planned).

**Rationale:**
- [TBD]

**IPv6:**  
Planned for future multi-region resiliency work.

---

# 3. GitOps & Deployment Decisions

## 3.1 ArgoCD as the GitOps Engine
**Decision:** Use ArgoCD for declarative deployments.

**Rationale:**
- Clear separation between desired state (Git) and actual state (cluster)  
- Built-in diffing, rollback, and auditability  
- Industry-standard for SRE/Platform teams  

---

## 3.2 Manual Promotion to Production
**Decision:** Staging uses automated sync; production requires manual approval.

**Rationale:**
- Prevents accidental production rollouts  
- Demonstrates controlled release governance  
- Mirrors real-world change management processes

# 4. Terraform Architecture Decisions

## 4.1 Modular Terraform Structure
**Decision:** Build reusable modules for VPC, EKS, Observability.

**Rationale:**
- Encourages composability and clarity  
- Mirrors enterprise Terraform patterns  
- Enables multi-region expansion  

---

## 4.2 State Management
**Decision:** Remote state in S3

**Rationale:**
- Prevents concurrent apply conflicts  
- Enables team collaboration  
- Supports multi-environment isolation  

---

## 4.3 Availability & Resiliency Strategy

**Decision:** Deploy workloads across multiple Availability Zones within a single AWS region.

**Rationale:**
- Protects against individual Availability Zone failures
- Provides high availability without the complexity of a multi-region design
- Aligns with the expected user base, which is primarily located within the United States
- Delivers an effective balance between reliability, operational simplicity, and cost

**Future Considerations:**
- Multi-region deployment may be evaluated in the future if availability requirements change. Potential enhancements include additional regional EKS clusters and Karpenter-managed capacity across multiple regions.

# 5. Security Decisions

## 5.1 Identity & Access Management

**Decision:** Use AWS Pod Identity rather than IAM Roles for Service Accounts (IRSA) for workload authentication.

**Rationale:**
- AWS Pod Identity is the strategic successor to IRSA and represents the direction of future AWS development
- Simplifies IAM integration by reducing the complexity associated with OIDC providers and role configuration
- Eliminates the need to manage long-lived AWS credentials within Kubernetes workloads
- Provides fine-grained access control aligned with AWS security best practices

**Tradeoff:**
- AWS Pod Identity is newer and has a smaller body of community documentation compared to IRSA
- Increases dependency on AWS-specific functionality

---

## 5.2 Private Networking

**Decision:** Deploy worker nodes and workloads within private subnets.

**Rationale:**
- Reduces exposure to the public internet
- Limits ingress and egress paths
- Aligns with enterprise security practices

---

## 5.3 Secrets Management

**Decision:** Use Bitnami Sealed Secrets for Kubernetes secrets and GitLab CI/CD variables for deployment credentials.

**Rationale:**
- Allows encrypted secrets to be safely stored within Git repositories
- Integrates directly with existing GitOps workflows
- Prevents plaintext secrets from being committed to source control
- Provides a practical solution while keeping operational complexity low

**Future Considerations:**
AWS Secrets Manager or HashiCorp Vault may be adopted in the future to provide centralized secret management, automated rotation, and enhanced auditing capabilities.
---

## 5.4 Least Privilege Access

**Decision:** Apply least privilege principles to AWS and Kubernetes permissions.

**Rationale:**
- Limits the blast radius of compromised workloads
- Reduces accidental privilege misuse
- Supports security best practices

---

## 5.5 Infrastructure as Code Security

**Decision:** Manage infrastructure changes through Terraform and GitOps workflows.

**Rationale:**
- Creates an auditable change history
- Reduces configuration drift
- Enables peer review before deployment

# 6. Security Decisions

## 6.1 Unified Observability Platform

**Decision:** Centralize application, Kubernetes, and AWS infrastructure observability within a single monitoring platform.

**Rationale:**
- Provides a unified operational view across both workloads and underlying infrastructure
- Simplifies incident response by reducing the number of tools required during investigations
- Enables correlation between application issues and AWS platform events
- Reduces operational overhead by standardizing monitoring, dashboards, logging, and alerting

**Components:**
- Prometheus
- Grafana
- Loki
- Alloy
- YACE
- AWS CloudWatch integrations

This approach allows engineers to monitor both Kubernetes workloads and supporting AWS infrastructure from a common operational interface.

---

## 6.2 Metrics Collection with Prometheus

**Decision:** Use Prometheus as the primary metrics collection platform.

**Rationale:**
- Industry-standard monitoring solution for Kubernetes environments
- Supports automatic service discovery through ServiceMonitors
- Enables collection of both infrastructure and application metrics
- Provides the metric data required to measure SLIs and track SLO compliance

**Alternatives Considered:**
- Datadog was evaluated as a fully managed observability platform, but was not selected due to its licensing costs and reduced flexibility compared to the open-source Prometheus ecosystem.
- Prometheus provides greater visibility into the underlying monitoring architecture and aligns more closely with the project's goal of demonstrating platform engineering and observability capabilities.

---

## 6.3 Centralised Logging with Loki

**Decision:** Aggregate application, Kubernetes, and AWS platform logs within Loki.

**Rationale:**
- Creates a single source of truth for operational logging
- Simplifies troubleshooting by eliminating the need to switch between multiple logging platforms
- Enables correlation between application failures and platform events
- Allows alerting and dashboarding to be configured from a single observability stack

**Implementation:**
In addition to Kubernetes application logs, AWS service logs such as CloudTrail and EKS control plane logs are ingested into Loki.

**Benefits:**
- Unified platform-wide visibility
- Simplified operational workflows
- Consistent query language and alerting configuration
- Ability to detect and alert on issues affecting both applications and supporting infrastructure

---

## 6.4 SLI-Based Monitoring

**Decision:** Monitor user-facing reliability indicators rather than infrastructure metrics alone.

**Rationale:**
- Measures actual user experience
- Aligns monitoring with reliability objectives
- Supports meaningful SLO development

---

## 6.5 Actionable Alerting

**Decision:** Alert on user-impacting symptoms rather than every infrastructure event.

**Rationale:**
- Reduces alert fatigue
- Improves signal-to-noise ratio
- Focuses operational effort on customer impact
