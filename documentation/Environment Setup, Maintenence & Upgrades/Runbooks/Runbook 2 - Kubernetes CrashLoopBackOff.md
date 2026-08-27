# Runbook 2: Kubernetes CrashLoopBackOff

## Purpose

This runbook provides a standard process for diagnosing, mitigating, and resolving Kubernetes CrashLoopBackOff incidents within the Workhorse platform.

Use this runbook when containers repeatedly restart and cannot remain healthy long enough to serve traffic.

A CrashLoopBackOff is not the root cause itself. It indicates that Kubernetes is repeatedly attempting to restart a container that starts and then exits or crashes. Kubernetes uses an exponential backoff delay between restart attempts.

---

# Trigger Conditions

## Symptoms

This runbook should be followed when one or more of the following symptoms are observed.

### Platform Alerts

- High Pod Restart Rate
- WorkhorseApplicationAvailabilityLow
- KubernetesPodCrashLooping
- DeploymentReplicaMismatch
- KubernetesContainerRestartSpike

### User Symptoms

- Application unavailable
- HTTP 5xx errors
- Login failures
- API request failures
- Blank or incomplete application pages
- Service intermittently available

### Kubernetes Indicators

```text
STATUS: CrashLoopBackOff
```

```text
Back-off restarting failed container
```

```text
READY 0/1
```

```text
RESTARTS increasing continuously
```

### Grafana Indicators

- Availability drops
- Restart count spikes
- Error rate increases
- Request volume falls unexpectedly
- Health check failures increase

---

# Severity Classification

## SEV-3

Single pod affected.

- Application remains available
- Redundant replicas healthy
- No user impact

---

## SEV-2

Multiple pods affected.

- Reduced redundancy
- Intermittent user impact
- Deployment partially unavailable

---

## SEV-1

Critical service unavailable.

- No healthy replicas
- Significant user impact
- Application outage
- Multiple deployments affected

---

# Dashboard Links

## Kubernetes Cluster Overview

```text
Grafana > Kubernetes / Views / Global
```

Purpose:

- Review cluster health
- Identify failed workloads
- Confirm broader platform impact

---

## Kubernetes Pods Dashboard

```text
Grafana > Kubernetes / Views / Pods
```

Purpose:

- View restart counts
- View pod status
- Identify CrashLooping workloads

---

## Kubernetes Namespaces Dashboard

```text
Grafana > Kubernetes / Views / Namespaces
```

Purpose:

- Compare desired replicas with available replicas
- Confirm rollout status
- Identify unhealthy deployments

---

## Workhorse Application Dashboard

```text
Grafana > Application Reliability
```

Purpose:

- Confirm user impact
- Review availability
- Review latency and error rate

---

## Logs via Grafana Explore

```text
Grafana > Explore
```

Purpose:

- Review application logs
- Review restart metrics
- Correlate failures with deployments

---

## ArgoCD

```text
ArgoCD UI > Applications
```

Purpose:

- Review recent deployments
- Check sync status
- Compare live state with Git

---

# Diagnosis Procedure

## Step 1: Confirm the CrashLoopBackOff

List pods:

```bash
kubectl get pods -n <namespace>
```

Example:

```text
NAME                    READY   STATUS             RESTARTS
web-64894bdfdf-nxdg2    0/1     CrashLoopBackOff   9
```

A pod with an increasing restart count and CrashLoopBackOff status should proceed through this runbook.

---

## Step 2: Identify the Restarting Container

Inspect the pod:

```bash
kubectl describe pod <pod-name> \
  -n <namespace>
```

Review:

```text
Containers:
```

and

```text
Last State:
```

Example:

```text
Last State:
  Terminated

  Reason: Error

  Exit Code: 1
```

Record:

- Container name
- Exit code
- Termination reason
- Restart count

CrashLoopBackOff can be caused by:

- Application exceptions
- Invalid configuration
- Missing secrets
- Failed health probes
- OOMKilled containers
- Dependency failures

---

## Step 3: Review Previous Container Logs

This is usually the most important troubleshooting step.

Retrieve logs from the failed container:

```bash
kubectl logs <pod-name> \
  -n <namespace> \
  --previous
```

For multi-container pods:

```bash
kubectl logs <pod-name> \
  -n <namespace> \
  -c <container-name> \
  --previous
```

Look for:

- Stack traces
- Panic messages
- Fatal configuration errors
- Missing files
- Authentication failures
- Database connection failures
- Port binding failures
- Application startup failures

Example:

```text
panic: failed to connect to database
```

```text
Config validation failed
```

```text
secret "api-key" not found
```

If Kubernetes returns:

```text
previous terminated container not found
```

the workload may not have restarted yet, or the pod may have been recreated.

---

## Step 4: Review Kubernetes Events

Retrieve events:

```bash
kubectl get events \
  -n <namespace> \
  --sort-by=.metadata.creationTimestamp
```

Look for:

```text
BackOff
Killing
Failed
Unhealthy
FailedMount
FailedScheduling
```

Common examples:

```text
Back-off restarting failed container
```

```text
Liveness probe failed
```

```text
MountVolume.SetUp failed
```

```text
secret not found
```

---

## Step 5: Determine the Root Cause Category

Review the termination reason.

### Application Crash

```text
Reason: Error
Exit Code: 1
```

Usually indicates:

- Application bug
- Invalid startup logic
- Missing dependency
- Invalid runtime argument

---

### OOMKilled

```text
Reason: OOMKilled
Exit Code: 137
```

Use the OOM Troubleshooting Runbook.

---

### Probe Failure

Events show:

```text
Liveness probe failed
```

or

```text
Startup probe failed
```

Container itself may be healthy but Kubernetes continuously restarts it.

---

### Missing Configuration

Typical evidence:

```text
ConfigMap not found
```

```text
Secret not found
```

```text
Environment variable missing
```

---

### Dependency Failure

Typical evidence:

```text
connection refused
```

```text
no such host
```

```text
timed out waiting for dependency
```

Examples:

- Database unavailable
- Redis unavailable
- Kafka unavailable
- DNS issues

---

## Step 6: Check Resource Utilization

Review container resource consumption:

```bash
kubectl top pods \
  -n <namespace> \
  --containers
```

Review node status:

```bash
kubectl top nodes
```

Verify whether:

- Memory exhaustion occurred
- CPU starvation occurred
- Node pressure occurred

If OOMKilled is identified, switch to the OOM runbook.

---

## Step 7: Review Recent Deployments

Review deployment history.

ArgoCD:

```text
Application History
```

Git:

```text
Review most recent commit with last known healthy commit - https://github.com/jresmith/workhorse-aws-terraform/commits/main/
```

Look for:

- Recent application release
- ConfigMap changes
- Secret changes
- Resource limit changes
- Probe changes
- Container image changes

A CrashLoopBackOff frequently begins immediately after a deployment.

---

# Common Root Cause Patterns

## Pattern 1: Application Startup Failure

Evidence:

```text
Exit Code: 1
```

Logs contain:

```text
panic
fatal
exception
```

Typical causes:

- Application bug
- Invalid startup argument
- Invalid configuration

---

## Pattern 2: Missing ConfigMap or Secret

Evidence:

```text
secret not found
```

```text
configmap not found
```

Typical causes:

- Resource deleted
- Incorrect namespace
- Typographical error
- Deployment references non-existent object

---

## Pattern 3: OOMKilled

Evidence:

```text
Reason: OOMKilled
```

Typical causes:

- Memory limit too low
- Memory leak
- Traffic spike

Refer to the OOM runbook.

---

## Pattern 4: Liveness Probe Failure

Evidence:

```text
Liveness probe failed
```

Typical causes:

- Probe path incorrect
- Application startup takes longer than expected
- Timeout values too aggressive
- Dependency check included in liveness probe

---

## Pattern 5: Dependency Failure

Evidence:

```text
connection refused
```

```text
dial tcp
```

```text
no such host
```

Typical causes:

- Database unavailable
- DNS failure
- Service unavailable

---

## Pattern 6: Port Conflict

Evidence:

```text
address already in use
```

Typical causes:

- Incorrect container configuration
- Multiple services using the same port

---

# Emergency Stabilisation

Use only when restoring service is the priority.

---

## Option 1: Roll Back the Deployment

If the issue started immediately after a release:

```bash
git revert <commit-id>
git push
```

Allow ArgoCD to reconcile.

This is usually the fastest recovery method.

---

## Option 2: Restart the Deployment

```bash
kubectl rollout restart deployment/<deployment-name> \
  -n <namespace>
```

Verify:

```bash
kubectl rollout status deployment/<deployment-name> \
  -n <namespace>
```

Note:

- Useful only if the underlying issue is temporary.
- Does not fix configuration or application defects.

---

## Option 3: Scale Back to a Known Good Version

Deploy the previous image version using GitOps.

Verify rollout completion:

```bash
kubectl rollout status deployment/<deployment-name> \
  -n <namespace>
```

---

## Option 4: Restore Missing Dependencies

Examples:

- Recreate missing Secret
- Restore ConfigMap
- Recover database connectivity
- Restore DNS resolution

Only perform emergency changes that follow approved operational procedures.

---

# GitOps Remediation Procedure

Permanent fixes must be implemented through Git.

Do not leave undocumented manual changes in the cluster.

---

## Step 1

Identify the source manifest.

Examples:

- Deployment
- Helm values
- ConfigMap
- Secret reference
- Kustomize patch

---

## Step 2

Implement the fix.

Examples:

```yaml
startupProbe:
```

```yaml
livenessProbe:
```

```yaml
env:
```

```yaml
resources:
```

```yaml
image:
```

---

## Step 3

Commit the change.

```bash
git add .
git commit -m "Fix CrashLoopBackOff root cause"
git push
```

---

## Step 4

Verify ArgoCD reconciliation.

```bash
argocd app get <application>
```

or

```bash
kubectl get applications -A
```

---

## Step 5

Verify deployment.

```bash
kubectl rollout status deployment/<deployment-name> \
  -n <namespace>
```

---

# Rollback Procedure

If remediation causes further instability:

Revert the change:

```bash
git revert <commit-id>
git push
```

Verify synchronization.

Confirm restored state in ArgoCD.

Verify deployment health.

---

# Recovery Verification

Recovery is complete only when all validation checks succeed.

---

## Pod Health

```bash
kubectl get pods -n <namespace>
```

Expected:

```text
READY = Desired state
STATUS = Running
RESTARTS stable
```

---

## Deployment Health

```bash
kubectl get deployment \
  -n <namespace>
```

Expected:

```text
AVAILABLE = DESIRED
```

---

## Event Validation

```bash
kubectl get events \
  -n <namespace> \
  --sort-by=.metadata.creationTimestamp
```

Verify no new:

```text
BackOff
Failed
Unhealthy
```

events appear.

---

## Application Validation

Verify:

- Availability restored
- Error rate returned to baseline
- Latency returned to baseline
- Traffic processing normally

---

## Grafana Validation

Confirm:

- Restart count stabilises
- No new CrashLoopBackOff workloads
- Availability metrics return to baseline
- Active alerts clear

---

# Escalation Criteria

Escalate immediately if:

- No healthy replicas remain
- Critical services are unavailable
- CrashLoopBackOff continues after remediation
- Multiple deployments affected
- Root cause cannot be identified within the incident response window
- Platform-wide failure is suspected

---

# Contacts

| Team | Responsibility |
|--------|--------|
| Platform Engineering | Kubernetes, EKS, Node Health |
| SRE Team | Incident Coordination |
| Application Owner | Application Behaviour and Logs |
| On-Call Engineer | Initial Incident Response |

---

# Success Criteria

The incident may be closed when:

- All affected pods are Running
- Restart counts remain stable
- No active CrashLoopBackOff conditions remain
- All alerts have cleared
- Root cause has been identified
- Permanent GitOps remediation has been merged
- ArgoCD reconciliation completed successfully
- Application availability returned to baseline