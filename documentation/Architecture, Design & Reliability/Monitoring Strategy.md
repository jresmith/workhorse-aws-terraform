# 🚧 Work in Progress

## Monitoring Strategy

* What to Monitor & why
* How alerts are structured
* How logs and Metrics connect
* Where we get logs
  - Application Logs
  - Load Balancer / Ingress Metrics
  - Syntetic Testing (vote-bot)
  - Client-Side (accessing UI myself)
* Dashboards I've built
  - Purpose
  - Key panels
  - Why these metrics matter
  - How to interpret anomolies 

## Expectations

* How can the app fail?
* What is an acceptable failure?
  - Malformed requetss faul
* Are all the users treated the same
* What is an error?
 - 400 or 500 from the app
 - 400 or 500 from ALB/Proxy/Ingress Controller

## Monitoring Ojectives

* List of Emojis can be viewed
  - Emojo Catalogue Avalibility
  - Emojo Catalogue Latency
* Votes can be cast
  - UI (web service) Availibility
  - UI (web service) Latency
  - Vote Cast (Voting Service) Availibility
  - Vote Cast (Voting Service) Latency
  - Vote Processing Success Rate
  - [End-to-end] Vote Processing time
* Leaderboard can be viewed

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

## How Metrics and Logs Work Together

Metrics and logs solve different problems.

### Metrics Answer

```text
What is happening?
```

Examples:

```text
Error rate increased.

Latency increased.

Pods restarted.

Traffic dropped.
```

Metrics are primarily used for:

- Dashboards
- Alerts
- SLO calculations
- Trend analysis

### Logs Answer

```text
Why is it happening?
```

Examples:

```text
Application exception.

Database timeout.

Authentication failure.

Failed API request.
```

Logs are used for troubleshooting after metrics or alerts identify an issue.

### Typical Investigation Workflow

```text
Alert Fires
        ↓
Dashboard Review
        ↓
Identify Impacted Service
        ↓
Inspect Logs
        ↓
Determine Root Cause
```

Example:

```text
High Error Rate Alert
        ↓
Grafana Shows Error Spike
        ↓
Loki Shows Database Timeouts
        ↓
Root Cause Identified
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

Collection flow:

```text
Application Containers
        ↓
stdout / stderr
        ↓
Promtail
        ↓
Loki
```

### Load Balancer / Service Mesh / Ingress Metrics

Traffic metrics provide visibility into client-facing requests.

Examples:

- Request volume
- Success rate
- Error rate
- Latency
- HTTP status codes

Sources include:

- Linkerd
- Kubernetes Services
- Ingress Controller
- AWS Load Balancer

### Synthetic Testing (Vote Bot)

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

## Availability Dashboard

### Purpose

Visualize service availability and successful request rates.

### Key Panels

- Request volume
- Success rate
- Error rate
- Burn rate

### Why These Metrics Matter

Availability is the primary indicator of customer impact.

### How to Interpret Anomalies

Examples:

```text
Increased burn rate
        ↓
Reliability degradation

Increasing error rate
        ↓
Application instability

Traffic with no successful responses
        ↓
Potential outage
```

---

## Latency Dashboard

### Purpose

Visualize application responsiveness.

### Key Panels

- p50 latency
- p95 latency
- p99 latency
- Vote latency

### Why These Metrics Matter

Users directly experience latency.

### How to Interpret Anomalies

Examples:

```text
Sudden p95 spike
        ↓
Performance regression

Steady latency increase
        ↓
Resource saturation

High latency during scaling
        ↓
Capacity constraint
```

---

## Infrastructure Dashboard

### Purpose

Monitor Kubernetes workload health.

### Key Panels

- Pod status
- Replica counts
- Pod restarts
- Resource utilisation
- HPA status

### Why These Metrics Matter

Infrastructure issues often occur before user-facing impact.

### How to Interpret Anomalies

Examples:

```text
Increasing restart count
        ↓
Application instability

Unavailable replicas
        ↓
Failed deployment

Pods NotReady
        ↓
Dependency issue
```

---

## Observability Dashboard

### Purpose

Monitor the health of the monitoring platform.

### Key Panels

- Prometheus health
- Loki health
- Alertmanager health
- Grafana health

### Why These Metrics Matter

If observability fails, troubleshooting becomes significantly harder.

### How to Interpret Anomalies

Examples:

```text
Prometheus Down
        ↓
Metrics unavailable

Alertmanager Down
        ↓
No alerts delivered

Loki Down
        ↓
Logs unavailable
```

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

# Monitoring Objectives

Monitoring objectives are based on validating key user journeys.

---

## Emoji Catalogue Can Be Viewed

### Objectives

- Emoji Catalogue Availability
- Emoji Catalogue Latency

### Questions

```text
Can users retrieve the available emojis?

How quickly can they retrieve them?
```

---

## Votes Can Be Cast

### UI (Web Service) Availability

Question:

```text
Can users access the voting interface?
```

### UI (Web Service) Latency

Question:

```text
How quickly does the UI respond?
```

### Vote Cast (Voting Service) Availability

Question:

```text
Can users successfully submit votes?
```

### Vote Cast (Voting Service) Latency

Question:

```text
How quickly are vote requests processed?
```

### Vote Processing Success Rate

Question:

```text
What percentage of vote requests complete successfully?
```

### End-to-End Vote Processing Time

Question:

```text
How long does it take from vote submission until the vote appears in the application?
```

---

## Leaderboard Can Be Viewed

### Objectives

- Leaderboard Availability
- Leaderboard Latency

### Questions

```text
Can users retrieve leaderboard data?

How quickly can leaderboard data be displayed?
```

---

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