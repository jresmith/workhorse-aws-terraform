# Runbook 1: Kubernetes OOMKilled and Node Memory Pressure

## Purpose

This runbook describes how to diagnose, mitigate, and permanently resolve Kubernetes memory-related incidents within the Workhorse platform.

Use this runbook when application containers are being terminated due to memory exhaustion or when Kubernetes nodes are experiencing memory pressure.

---

# Trigger Conditions

## Symptoms

This runbook should be followed when one or more of the following symptoms are observed:

### Platform Alerts

- ContainerOOMKilled
- NodeMemoryHeadroomLow __(Alert to be implement in the future)__
- KubernetesNodeMemoryPressure __(Alert to be implement in the future)__
- High Pod Restart Rate __(Alert to be implement in the future)__

### User Symptoms

- Increased application latency
- HTTP 5xx errors
- Intermittent request failures
- Service instability
- Pods repeatedly restarting

### Kubernetes Indicators

```text
Reason: OOMKilled
Exit Code: 137
```

```text
MemoryPressure=True
```

```text
Status: Evicted
```

### Prometheus Indicators

- Sudden drop in application availability
- Increased pod restart metrics
- Node memory utilization exceeding 90%
- Application memory usage approaching configured limits

---

# Severity Classification

## SEV-3

Single pod affected.

- Service remains available
- Restart count is increasing
- No customer impact

## SEV-2

Multiple pods affected.

- Reduced redundancy
- Intermittent user impact
- Memory pressure present

## SEV-1

Widespread impact.

- Multiple services failing
- Node instability
- Memory pressure across multiple nodes
- Significant customer impact

---

# Dashboard Links

## Grafana Dashboards

### Kubernetes Cluster Overview

```text
Grafana > Kubernetes / Views / Global
```

### Kubernetes Nodes

```text
Grafana > Kubernetes / Views / Nodes
```

### Kubernetes Pods

```text
Grafana > Kubernetes / Views / Pods
```

### Workhorse Application Dashboard

```text
Grafana > Application Reliability
```

### Alertmanager

```text
Alertmanager > Alerts
```

---

# Diagnosis Procedure

## Step 1 - Confirm an OOM Event

Inspect pod status:

```bash
kubectl get pods -n <namespace>
```

Identify pods with elevated restart counts.

Example:

```text
NAME                  READY   STATUS    RESTARTS
web-7df4568f8f        1/1     Running   4
```

---

Inspect the pod:

```bash
kubectl describe pod <pod-name> \
  -n <namespace>
```

Look for:

```text
Last State:
  Terminated
  Reason: OOMKilled
  Exit Code: 137
```

---

## Step 2 - Distinguish OOMKilled vs Eviction

### OOMKilled

Container exceeded available memory and was terminated by the Linux kernel. Only the affected container is terminated. 

Evidence:

```text
Reason: OOMKilled
Exit Code: 137
```

### Pod Eviction

Kubelet removed the entire pod because the node was under memory pressure.

Evidence:

```text
Status: Failed
Reason: Evicted
```

Check:

```bash
kubectl describe pod <pod-name> \
  -n <namespace>
```

---

## Step 3 - Review Kubernetes Events

Retrieve recent events:

```bash
kubectl get events -A \
  --sort-by=.metadata.creationTimestamp
```

Look for:

```text
OOMKilling
Killing
Evicted
MemoryPressure
FailedScheduling
```

---

## Step 4 - Identify the Affected Worker Node

Determine which node hosts the workload:

```bash
kubectl get pod <pod-name> \
  -n <namespace> \
  -o wide
```

Example:

```text
NAME          NODE
web-123       ip-10-0-12-45
```

Record the node name.

---

## Step 5 - Verify Node Memory Pressure

Inspect node status:

```bash
kubectl describe node <node-name>
```

Look for:

```text
Conditions:

MemoryPressure   True
```

Node memory pressure indicates that available node memory is critically low.

---

## Step 6 - Review Current Memory Utilization

Review node memory usage:

```bash
kubectl top nodes
```

Example:

```text
NAME            MEMORY%
ip-10-0-12-45   95%
```

Review pod memory usage:

```bash
kubectl top pods \
  -n <namespace> \
  --containers \
  --sort-by=memory
```

Identify workloads consuming abnormal amounts of memory.

---

## Step 7 - Retrieve Previous Container Logs

If the pod has restarted:

```bash
kubectl logs <pod-name> \
  -n <namespace> \
  --previous
```

Review logs immediately prior to termination.

Look for:

- Memory allocation failures
- Large batch processing
- Cache growth
- Increased request volume
- Runtime OOM exceptions

If Kubernetes returns:

```text
previous terminated container not found
```

the workload has not restarted since creation.

---

## Step 8 - Review Historical Memory Usage

### Working Set Memory

```promql
sum by (namespace,pod)(
  container_memory_working_set_bytes{
    namespace=~"emojivoto-.*"
  }
)
```

---

### Memory Usage Relative to Limits

```promql
sum by (namespace,pod)(
  container_memory_working_set_bytes{
    namespace=~"emojivoto-.*"
  }
)
/
sum by (namespace,pod)(
  kube_pod_container_resource_limits{
    namespace=~"emojivoto-.*",
    resource="memory",
    unit="byte"
  }
)
```

Interpretation:

```text
0.50 = 50% of limit
0.80 = 80% of limit
1.00 = at configured limit
>1.00 = likely OOM candidate
```

---

### Node Memory Headroom

```promql
node_memory_MemAvailable_bytes
/
node_memory_MemTotal_bytes
```

Threshold guidance:

```text
<20% = Warning
<10% = Critical
```

---

## Step 9 - Compare Requests, Limits and Actual Usage

Retrieve configured values:

```bash
kubectl get pod <pod-name> \
  -n <namespace> \
  -o yaml
```

Example:

```yaml
resources:
  requests:
    memory: 64Mi
  limits:
    memory: 128Mi
```

Compare these values with Grafana memory consumption.

Ask:

- Does usage exceed configured limits?
- Do requests represent actual consumption?
- Is the workload consistently using more memory than requested?

---

# Common Root Cause Patterns

## Resource Limits Too Low

Evidence:

```text
Memory usage repeatedly reaches limit
OOMKilled events occur
```

---

## Resource Requests Too Low

Evidence:

```text
Node becomes overcommitted
Scheduler places too many workloads on a node
```

---

## Memory Leak

Evidence:

```text
Memory usage grows continuously
```

without stabilising.

---

## Traffic Spike

Evidence:

```text
Memory usage increases rapidly
after elevated request volume
```

---

## Cache Growth

Evidence:

```text
Memory usage remains elevated
after traffic returns to normal
```

---

# Emergency Stabilisation

Use only when restoring service is the priority.

---

## Option 1 - Restart Deployment

```bash
kubectl rollout restart deployment/<deployment-name> \
  -n <namespace>
```

Verify:

```bash
kubectl rollout status deployment/<deployment-name> \
  -n <namespace>
```

---

## Option 2 - Delete Affected Pod

```bash
kubectl delete pod <pod-name> \
  -n <namespace>
```

Deployment controller will create a replacement pod.

---

## Option 3 - Scale Down Workload

```bash
kubectl scale deployment <deployment-name> \
  --replicas=0 \
  -n <namespace>
```

Scale back when resources are available.

---

## Option 4 - Scale Node Capacity (Planned Feature)

If Cluster Autoscaler is available:

- Confirm scaling activity
- Verify node provisioning
- Confirm workloads reschedule successfully

---

# GitOps Remediation Procedure

Permanent fixes must be performed through GitOps.

Do not leave undocumented manual changes in the cluster.

---

## Step 1

Update workload manifest.

Example:

```yaml
resources:
  requests:
    cpu: 50m
    memory: 128Mi

  limits:
    cpu: 500m
    memory: 256Mi
```

---

## Step 2

Commit change:

```bash
git add .
git commit -m "Right-size memory requests and limits"
git push
```

---

## Step 3

Verify reconciliation.

```bash
argocd app get <application>
```

or

```bash
kubectl get applications -A
```

---

## Step 4

Confirm new resources are live.

```bash
kubectl get deployment <deployment-name> \
  -n <namespace> \
  -o yaml
```

---

# Rollback Procedure

If remediation increases instability:

---

Revert the change:

```bash
git revert <commit-id>
git push
```

---

Verify GitOps reconciliation:

```bash
argocd app sync <application>
```

---

Confirm restored configuration:

```bash
kubectl get deployment \
  -n <namespace> \
  -o yaml
```

---

# Recovery Verification

Recovery is complete only when all validation checks succeed.

---

## Application Health

```bash
kubectl get pods \
  -n <namespace>
```

Confirm:

```text
READY = Desired replicas
STATUS = Running
RESTARTS stable
```

---

## Node Health

```bash
kubectl describe node <node-name>
```

Confirm:

```text
MemoryPressure = False
```

---

## Memory Utilisation

```bash
kubectl top nodes
```

Verify adequate memory headroom exists.

---

## Kubernetes Events

```bash
kubectl get events -A \
  --sort-by=.metadata.creationTimestamp
```

Confirm no new:

```text
OOMKilling
Evicted
MemoryPressure
```

events are present.

---

## Grafana Validation

Confirm:

- Memory usage is stable
- Restart rate returns to baseline
- Application availability returns to baseline
- Active alerts have cleared

---

# Escalation Criteria

Escalate immediately if:

- More than one node reports MemoryPressure
- OOMKilled events continue after remediation
- Platform availability is impacted
- Node becomes NotReady
- Critical application workloads cannot recover

---

# Contacts

| Team | Responsibility |
|--------|--------|
| Platform Engineering | Kubernetes, Nodes, EKS |
| SRE Team | Incident coordination |
| Application Owner | Application memory behaviour |
| On-Call Engineer | Immediate response |

---

# Success Criteria

Incident may be closed when:

- No active OOMKilled events occur for 24 hours
- Node memory pressure is cleared
- Workload remains stable
- Restart count remains unchanged
- All alerts have cleared
- Resource configuration has been committed to Git and reconciled successfully