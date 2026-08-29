# Monitoring & Alerting Strategy

## Purpose

The purpose of monitoring within Workhorse is to provide visibility into the health, performance, reliability, and operability of the platform.

Monitoring is designed to answer three questions:

```text
Is the platform healthy?

Is the application working correctly?

Are users successfully achieving their goals?
```

Workhorse follows Site Reliability Engineering (SRE) principles by prioritizing customer-facing signals over infrastructure metrics alone.

When possible, alerts are based on service behaviour and user outcomes rather than internal resource consumption.

---

# Monitoring Objectives

Monitoring objectives are based on validating key user journeys.

---

## Emoji Catalogue Can Be Viewed

| Objective | Question |
|------------|----------|
| Emoji Catalogue Availability | Can users retrieve the available emojis? |
| Emoji Catalogue Latency | How quickly can they retrieve them? |

---

## Votes Can Be Cast

| Objective | Question |
|------------|----------|
| UI (Web Service) Availability | Can users access the voting interface? |
| UI (Web Service) Latency | How quickly does the UI respond? |
| Vote Cast (Voting Service) Availability | Can users successfully submit votes? |
| Vote Cast (Voting Service) Latency | How quickly are vote requests processed? |
| Vote Processing Success Rate | What percentage of vote requests complete successfully? |
| End-to-End Vote Processing Time | How long does it take from vote submission until the vote appears in the application? |

---

## Leaderboard Can Be Viewed

| Objective | Question |
|------------|----------|
| Leaderboard Availability | Can users retrieve leaderboard data? |
| Leaderboard Latency | How quickly can leaderboard data be displayed? |

---

# Reliability Expectations

## How Can The Application Fail?

Examples include:

```text
Service unavailable

Requests timing out

High latency

Vote submission failures

Application crashes

Database connectivity failures

Ingress failures

Load balancer failures

Observability platform failures
```

---

## What Is An Acceptable Failure?

Not every failed request represents a reliability issue.

Expected failures include:

```text
Malformed requests

Invalid parameters

Unsupported operations

Incorrect URLs

User-generated errors
```

These may legitimately generate 4xx responses.

---

## Are All Users Treated Equally?

Yes.

Workhorse does not currently differentiate between users when calculating SLIs, SLOs, or error budgets.

All requests contribute equally towards reliability calculations.

---

## What Is Considered An Error?

Workhorse defines errors as requests that fail to achieve the intended outcome.

### Application Errors

Examples:

```text
HTTP 5xx Responses

Unhandled Exceptions

Failed Vote Processing
```

### Platform Errors

Examples:

```text
ALB 5xx

Ingress Controller 5xx

Linkerd Routing Failures

Proxy Failures
```

### Potential Client Errors

Examples:

```text
Unexpected HTTP 4xx

Vote Submission Rejected

Application Validation Errors
```

Expected user-generated 4xx responses may be excluded from SLO calculations where appropriate.

---


# Monitoring Strategy

## What We Monitor and Why

Workhorse monitors signals across multiple layers of the stack.

### Infrastructure

Infrastructure monitoring validates that Kubernetes is capable of running workloads successfully.

Examples:

- Node health
- Pod health
- Deployment health
- Horizontal Pod Autoscaler behaviour
- Resource exhaustion

Questions answered:

```text
Can workloads run?

Can workloads scale?

Are workloads healthy?
```

### Services

Service monitoring validates application behaviour.

Examples:

- Request volume
- Error rate
- Request latency
- Successful request rate

Questions answered:

```text
Can users successfully interact with the application?

Are requests succeeding?

Is performance acceptable?
```

### Reliability Objectives

Workhorse defines Service Level Objectives (SLOs) that represent the expected user experience.

Examples:

- Availability
- Latency
- Transaction success rates

Questions answered:

```text
Is the service meeting its reliability goals?

How quickly is the error budget being consumed?
```

### Observability Platform

The monitoring stack itself is monitored.

Examples:

- Prometheus availability
- Alertmanager availability
- Grafana availability
- Loki availability

Questions answered:

```text
Can we still observe the system?

Will alerts continue to be delivered?
```

---

## Signal Sources

Workhorse collects telemetry from multiple sources to validate both platform health and user experience.

### Application Logs

Application logs provide detailed information about application behaviour.

Examples:

- Exceptions
- Timeouts
- Failed requests
- Startup failures

### Load Balancer / Service Mesh / Ingress Metrics

Traffic metrics provide visibility into client-facing requests.

Examples:

- Request volume
- Success rate
- Error rate
- Latency
- HTTP status codes

Sources include:

- Kubernetes Services
- Ingress Controller
- AWS Load Balancer

### Synthetic Testing (Vote Bot) [PLANNED]

Synthetic traffic continuously exercises the application.

Purpose:

```text
Detect failures before real users encounter them.
```

Examples:

- Browsing emojis
- Casting votes
- Measuring vote latency
- Measuring availability

Synthetic testing provides a known and repeatable workload.

### Manual User Testing

The application is continuously validated through direct usage.

Examples:

- Viewing the emoji catalogue
- Casting votes
- Viewing the leaderboard

This helps validate that monitoring data reflects real-world user experience.

---

# Dashboards

Grafana dashboards provide operational visibility into the platform.

## Platform Dashboards

### Application Reliability

<img width="1915" height="954" alt="Application Reliability" src="https://github.com/user-attachments/assets/d86a4047-2b80-4369-bf6b-8dd272231502" />

### Kubernetes Views Pods

<img width="1912" height="952" alt="Kubernetes Views Pods" src="https://github.com/user-attachments/assets/e870ab40-c03c-45a2-bfc6-46814151d28a" />

### Kubernetes Views Nodes

<img width="1908" height="953" alt="Kubernetes Views Nodes" src="https://github.com/user-attachments/assets/a1c097b9-e9c3-460e-85d5-a636fbdd2330" />

### Kubernetes Views Namespaces

<img width="1915" height="958" alt="Kubernetes Views Namespaces" src="https://github.com/user-attachments/assets/ebaca1f3-d847-47c5-8889-7de0dab89786" />

### Kubernetes Views Global

<img width="1914" height="953" alt="Kubernetes Views Global" src="https://github.com/user-attachments/assets/d8a7818a-f6c8-45dd-bbbf-fb15b7e0f4d2" />

### Kubernetes System CoreDNS

<img width="1917" height="961" alt="Kubernetes System CoreDNS" src="https://github.com/user-attachments/assets/f1279b7e-baa0-4ded-b06e-f7aab2603827" />

### Kubernetes System API Server

<img width="1920" height="947" alt="Kubernetes System API Server" src="https://github.com/user-attachments/assets/bb73183f-0444-48e4-94c4-7a5972004581" />

## Logging Dashboards

### Loki Kubernetes Logs

<img width="1906" height="957" alt="Loki Kubernetes Logs" src="https://github.com/user-attachments/assets/100dfb57-bb67-4041-a3e9-5f4c58d8991e" />

### EKS Control Plane Logs

<img width="1909" height="959" alt="EKS Control Plane" src="https://github.com/user-attachments/assets/f16c1e47-87f4-47be-b404-df2ee0403d34" />

### AWS Route 53 DNS Logs

<img width="1880" height="955" alt="Route53 DNS Activity" src="https://github.com/user-attachments/assets/245463f9-6e2f-4331-bfa7-4f1f1c486e0a" />

### VPC Flow Logs

<img width="1912" height="893" alt="VPC Flow Logs" src="https://github.com/user-attachments/assets/03c5ffba-d880-4faf-8a8e-b956722dc43d" />

## Misc

### Voting Dashboard

<img width="1887" height="798" alt="Voting Dashboard" src="https://github.com/user-attachments/assets/77e8eb52-c4a4-402d-be07-febeed22e1c7" />

# Alert Routing Strategy

Alertmanager routes alerts based on:

- Environment
- Alert Category
- Severity

Alert Categories:

```text
Infrastructure
Service
SLO
```

Environment-specific Slack channels are used to maintain a high signal-to-noise ratio.

Example:

```text
dev-platform-alerts
dev-service-alerts
dev-slo-alerts

staging-platform-alerts
staging-service-alerts
staging-slo-alerts

prod-platform-alerts
prod-service-alerts
prod-slo-alerts
```

<img width="1918" height="957" alt="Screenshot 2026-08-20 at 4 33 28 PM" src="https://github.com/user-attachments/assets/e6381e3c-a3d1-4b6c-bbd3-eadd4519f126" />

---

## How Alerts Are Structured

Alerts are grouped into logical operational categories.

### Infrastructure Alerts

Platform issues that may eventually impact users.

Examples:

- DeploymentReplicasMismatch
- PodCrashLooping
- ContainerOOMKilled
- PodNotReady
- HPAMaxReplicasReached

### Service Alerts

Application issues that affect behaviour but may not yet represent an SLO breach.

Examples:

- High Error Rate
- No Successful Requests

### Availability SLO Alerts

Customer-impacting availability issues.

Examples:

- Burn Rate Urgent
- Burn Rate High
- Burn Rate Medium
- Burn Rate Low

### Latency SLO Alerts

Customer-impacting performance issues.

Examples:

- RequestLatencySLOBreach
- VoteLatencySLOBreach

### Performance Degradation Alerts

Early warning indicators.

Examples:

- Response Time Degraded 20%
- Response Time Twice Baseline

### Observability Alerts

Failures within the monitoring platform itself.

Examples:

- PrometheusDown
- AlertmanagerDown
- GrafanaDown
- LokiDown

---

# Summary

Workhorse implements a layered observability strategy combining:

- Infrastructure Monitoring
- Service Monitoring
- SLO Monitoring
- Performance Monitoring
- Synthetic Monitoring
- Dashboarding
- Log Aggregation
- Alerting

The primary objective is to ensure users can:

- View the emoji catalogue
- Cast votes successfully
- View leaderboard results

while providing sufficient visibility to rapidly detect, investigate, and resolve operational issues within the platform.


