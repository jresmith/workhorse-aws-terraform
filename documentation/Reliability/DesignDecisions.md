# Design Decisions

## Purpose
This document explains the architectural decisions, tradeoffs, and ationalebehind the Workhorse platform. It is written to demonstrate engineering maturity, reliability thinking, and the ability to justify technical choices in a real SRE/Platform Engineering environment.

---

## 1. Platform Goals
The platform was designed around four core objectives:

- **Reliability** — predictable behavior under load, failure isolation, and clear SLOs  
- **Scalability** — horizontal scaling, autoscaling, and multi‑AZ readiness  
- **Operational Safety** — GitOps workflows, controlled promotion, and safe production defaults  
- **Observability** — metrics, logs, and actionable alerting tied to SLOs  

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
**Decision:** Use HPA based on CPU + custom Prometheus metrics.

**Rationale:**
- CPU alone is insufficient for real workloads  
- Custom metrics allow scaling based on latency, queue depth, or request rate  
- Demonstrates production-grade autoscaling behavior  

**Why not KEDA?**
- KEDA adds another operator; HPA + Prometheus is more standard for SRE interviews  

---

## 2.4 Networking & IP Strategy
**Decision:** Use AWS VPC CNI with **warm ENIs** and **prefix delegation** (planned).

**Rationale:**
- Warm ENIs reduce cold-start latency during scaling events  
- Prefix delegation increases pod density and reduces IP exhaustion  
- Matches real-world scaling patterns  

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
**Decision:** Build reusable modules for VPC, EKS, IAM, and Observability.

**Rationale:**
- Encourages composability and clarity  
- Mirrors enterprise Terraform patterns  
- Enables multi-region expansion  

---

## 4.2 State Management
**Decision:** Remote state in S3 with DynamoDB locking.

**Rationale:**
- Prevents concurrent apply conflicts  
- Enables team collaboration  
- Supports multi-environment isolation  

---

## 4.3 DNS Record Conflicts (Known Issue)
**Decision:** Investigate disappearing DNS records when staging and production are deployed simultaneously.

**Rationale:**
- Indicates potential lifecycle conflicts or shared naming  
- Provides a real-world case study for debugging Terraform drift  

**Why this matters:**
- Demonstrates operational troubleshooting skills  
- Shows understanding of Terraform resource lifecycle  

---

## 4.4 Multi-AZ & Multi-Region Expansion
**Decision:** Expand to multiple AZs and regions as part of SLO resiliency planning.

**Rationale:**
- AZ redundancy protects against localized failures  
- Multi-region supports disaster recovery and global reliability  
- Aligns with SRE best practices for availability targets  

---

## 4.5 Cluster Autoscaler / Karpenter
**Decision:** Adopt Karpenter for node lifecycle management.

**Rationale:**
- Faster scaling reactions  
- Better bin-packing and cost efficiency  
- Simplifies node group configuration  

**Production sync policy:**
```yaml
syncPolicy:
  automated:
    prune: false
