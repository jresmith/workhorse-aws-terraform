# 🚧 Work in Progress

## Runbooks

* If X happens, follow these steps
  - Pod CrashLoopBackOff
  - ArgoCD Out of Sync
  - Loki ingestion failing
  - Prometheus scraping failures
* Each must include:
  - Clear Trigger Conditions (Symptoms)
  - How to diagnose with Step-by-Step troubleshooting procedures
  - Links to Dashboards and Monitoring Tools
  - Root cause patterns
  - Esculation Criteroa and Contact Information
  - Recovery & Verifiction Steps

Example #1

Create an OOM troubleshooting runbook containing:

- How to distinguish `OOMKilled` from pod eviction
- How to identify the affected worker node
- How to retrieve previous container logs
- PromQL queries for historical memory usage
- How to compare requests, limits, and working set
- How to verify node memory pressure
- Emergency stabilization options
- GitOps remediation procedures
- Rollback procedures
- Post-recovery validation steps