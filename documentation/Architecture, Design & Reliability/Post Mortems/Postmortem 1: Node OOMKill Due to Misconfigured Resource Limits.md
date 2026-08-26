# Postmortem: Node OOMKill Due to Misconfigured Resource Limits

## Incident Summary

A workload in the Workhorse Kubernetes environment experienced repeated container restarts due to memory exhaustion. The application remained partially available, but users experienced intermittent request failures while replacement containers were created and became ready.

Investigation determined that the workload's configured memory request significantly understated its actual runtime requirements and an appropriate memory limit had not been configured. This allowed Kubernetes to schedule workloads based on unrealistic resource requirements, resulting in node memory pressure and eventual container termination by the Linux OOM killer.

The incident highlighted weaknesses in resource governance, capacity planning, and observability coverage within the platform.

This postmortem is intended to be blameless and focuses on understanding how the system behaved, why existing controls failed to detect the issue earlier, and how the platform can be improved.

---

# Incident Metadata

| Field | Value |
|---------|---------|
| Incident ID | WH-2026-002 |
| Incident Type | Resource Exhaustion |
| Severity | SEV-2 |
| Environment | Development |
| Status | Resolved |
| Primary Impact | Application instability and intermittent request failures |
| Root Cause | Misconfigured memory requests and limits |
| Detection Method | Pod restart investigation and Kubernetes events |
| Duration | Until deployment configuration was corrected |

---

# Executive Summary

The Workhorse platform experienced application instability after a workload exceeded available memory resources.

The workload had been deployed with resource requests that were significantly below its normal operating consumption. Because Kubernetes schedules pods based on resource requests, the scheduler placed workloads onto nodes under the assumption that they would consume less memory than they actually required.

As application demand increased, memory usage grew beyond the node's available headroom. The Linux kernel terminated the affected container to protect node stability, resulting in repeated container restarts and temporary service degradation.

Although pod restart monitoring identified the symptoms, Workhorse lacked proactive alerts for low node memory headroom and workloads approaching configured memory limits. As a result, the issue was detected after customer impact had already begun.

The immediate issue was resolved by adjusting workload resource requests and limits through the GitOps workflow and allowing ArgoCD to reconcile the updated configuration.

---

# Customer Impact

## Impact Summary

Users experienced intermittent service degradation while affected containers repeatedly restarted.

### Observed Symptoms

- Increased request latency
- Intermittent request failures
- Reduced application availability
- Elevated pod restart counts
- Increased operational investigation activity

### What Was Not Impacted

- Kubernetes control plane
- GitOps tooling
- ArgoCD reconciliation
- Prometheus monitoring
- Grafana dashboards
- Loki logging pipeline

---

# Detection

## How the Incident Was Detected

Investigation began after elevated pod restart counts were observed.

The following evidence was collected:

```bash
kubectl get pods -n emojivoto-dev
```

```text
RESTARTS = 3
```

Further inspection identified the container termination reason:

```bash
kubectl describe pod web-64894bdfdf-nxdg2 \
  -n emojivoto-dev
```

```text
Last State:
  Terminated
  Reason: OOMKilled
  Exit Code: 137
```

Node-level investigation then identified memory pressure:

```bash
kubectl describe node minikube
```

```text
MemoryPressure   True
```

---

# Timeline

> Times are representative and should be updated to match actual incident evidence.

| Time | Event |
|--------|--------|
| 09:00 | Application deployment running normally |
| 09:12 | Memory consumption begins increasing |
| 09:18 | Node memory headroom falls below safe operating threshold |
| 09:21 | Linux OOM killer terminates application container |
| 09:22 | Kubernetes restarts workload |
| 09:24 | Additional OOM termination occurs |
| 09:27 | Elevated restart count noticed |
| 09:30 | Investigation initiated |
| 09:37 | Root cause narrowed to resource configuration |
| 09:45 | Corrected resource configuration committed to Git |
| 09:48 | ArgoCD reconciles deployment |
| 09:52 | Workload stabilizes |
| 10:00 | Incident declared resolved |

---

# Technical Analysis

## What Happened

The workload was configured with resource values similar to:

```yaml
resources:
  requests:
    cpu: 10m
    memory: 32Mi
  limits:
    cpu: 1000m
```

The application's actual memory consumption was substantially higher than the declared request.

Kubernetes uses resource requests during scheduling decisions. Because the request value understated actual memory demand, the scheduler believed sufficient capacity existed on the node when it did not.

As the application workload increased, memory consumption exceeded available node headroom.

The Linux kernel's OOM killer terminated the container to recover memory and preserve overall node health.

The Deployment controller immediately created a replacement container, restoring service temporarily before the cycle repeated.

---

## Why Existing Defences Failed

The platform contained controls that detected application failure but lacked controls that detected the approach to failure.

### Controls That Worked

- Kubernetes restarted failed containers automatically.
- Prometheus continued collecting metrics.
- ArgoCD allowed deployment updates to be delivered quickly.
- Node remained operational.

### Controls That Failed

- No alert for node memory headroom depletion.
- No alert when containers approached memory limits.
- No admission controls enforcing memory requests and limits.
- No right-sizing process for workload resources.
- No load-testing validation before deployment.

---

# Root Cause

## Primary Root Cause

The workload was deployed with memory requests that significantly underestimated normal operating consumption and without an appropriate memory limit configuration.

This caused Kubernetes scheduling decisions to be based on incorrect assumptions regarding memory usage.

When application demand increased, node memory became exhausted, resulting in container termination by the OOM killer.

---

# Contributing Factors

The following factors contributed to the incident:

### Resource Management

- Memory requests did not represent actual workload demand.
- Memory limits were missing or unsuitable.
- Workload resource settings were not regularly reviewed.

### Platform Governance

- No policy required memory requests and limits.
- No admission controls validated resource configuration.
- No automated right-sizing review process existed.

### Observability

- No alert for low node memory headroom.
- No alert for memory usage relative to configured limits.
- Detection occurred after application impact began.

### Capacity Planning

- Capacity planning focused on average consumption.
- Burst behaviour was not sufficiently considered.
- Node-level resource contention was underestimated.

---

# Five Whys

### Why did users experience service instability?

Containers restarted unexpectedly and became temporarily unavailable.

### Why were containers restarting?

The Linux kernel terminated the application process.

### Why did the kernel terminate the process?

The node ran out of available memory.

### Why did the node run out of memory?

The workload consumed significantly more memory than Kubernetes expected.

### Why did Kubernetes have an incorrect expectation?

Resource requests and limits did not accurately reflect actual workload requirements.

---

# Resolution

## Immediate Recovery

Application availability was restored by restarting the deployment and monitoring workload health while investigation continued.

```bash
kubectl get deployment -n emojivoto-dev
kubectl rollout restart deployment/web -n emojivoto-dev
```

Deployment stability was verified through:

```bash
kubectl rollout status deployment/web \
  -n emojivoto-dev
```

## Permanent Fix

Resource configuration was updated through GitOps to align with observed workload behaviour.

Example configuration:

```yaml
resources:
  requests:
    cpu: 50m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi
```

The change was committed to the repository and reconciled automatically through ArgoCD.

Post-deployment validation confirmed:

- Stable memory consumption
- No further OOMKilled events
- Reduced restart count
- Healthy node memory headroom

---

# Lessons Learned

## What Went Well

- Kubernetes self-healing reduced outage duration.
- Monitoring data remained available throughout the incident.
- GitOps enabled rapid and auditable remediation.
- Root cause was identifiable using standard Kubernetes tooling.

## What Went Poorly

- Resource configuration had not been validated against observed usage.
- Detection occurred after customer impact.
- No alerting existed for approaching memory exhaustion.
- Platform policies did not enforce minimum resource standards.

## Where We Got Lucky

- The node remained healthy enough for Kubernetes to continue scheduling replacement workloads.
- Impact was limited to a development environment.
- Platform observability remained intact during investigation.

---

# Action Items

## High Priority

### Enforce Resource Standards

**Owner:** Platform Team

Implement admission policies requiring:

- CPU requests
- Memory requests
- Memory limits

### Add Node Memory Alerts

**Owner:** Platform Team

Create alerts for:

- Low available node memory
- Node memory pressure
- Excessive memory utilisation

### Add OOM Detection Alerts

**Owner:** Platform Team

Create alerts for:

- OOMKilled containers
- Abnormal pod restart rates

---

## Medium Priority

### Workload Right-Sizing Review

**Owner:** Application Engineering

Review all workloads for:

- Resource requests
- Resource limits
- Historical memory consumption

### Capacity Planning Review

**Owner:** Platform Team

Establish minimum memory headroom requirements for all environments.

---

## Low Priority

### Documentation

**Owner:** Platform Team

Create an OOM troubleshooting runbook covering:

- OOMKilled investigation process
- Node memory pressure analysis
- Prometheus queries
- Emergency recovery procedures
- GitOps remediation workflow

---

# Long-Term Preventative Actions

The Workhorse platform will adopt the following improvements:

1. Enforce resource requests and limits through policy.
2. Alert on low node memory headroom before customer impact.
3. Alert when workloads approach memory limits.
4. Perform periodic resource right-sizing reviews.
5. Validate workload behaviour under load.
6. Maintain documented recovery procedures.
7. Include resource governance in platform standards.

---

# Final Root Cause Statement

The incident occurred because workload memory requests and limits did not accurately represent actual resource consumption. Kubernetes therefore made scheduling decisions based on incorrect assumptions, resulting in node memory exhaustion and container termination by the Linux OOM killer. Existing monitoring detected the failure but did not provide sufficient visibility into the conditions leading up to the failure.