# 🚧 Work in Progress

## Summary of Documentation

This document provides an overview of SLIs, SLOs & SLAs, including how they are defined, how they should be derived from application requirements, and how they should be monitored.

SLIs (Service Level Indicators) are mesurables signals that we use to quantify the user experience of a service. They measure outcomes that matter to the end user, such as availability, latency, success rate, correctness & freshness.

They are not designed to identify root cause or to measure backend services. In this environment we use Prometheus to track SLIs, which scrapes a /metrics endpoint with returns application metrics for the application we want to track. However, application metrics alone do not provide a complete picture of service reliability. A user may experience an outage caused by DNS, load balancing, networking, Kubernetes, or cloud infrastructure even when the application itself is healthy.
```
User > AWS Load Balancer > EKS > Service > Pod > Application
```
For this reason, SLIs should be measured as close to the user as possible and may incorporate data from multiple sources, including Prometheus, Kubernetes, AWS Load Balancer metrics, and synthetic monitoring. This ensures that SLIs reflect the overall service experience rather than the behaviour of a single component within the system.

Correctness is also an important aspect of user experience to measure. For example, if a vote is counted for the wrong emoji, the request may still return successfully, but the outcome is incorrect from the user's perspective. This would be considered a correctness failure.

Freshness measures how quickly newly generated data becomes visible to users. In this application, a freshness SLI could measure the delay between a vote being accepted and the leaderboard reflecting the updated result.

## User Journey

| User Journey           | SLI                    |
| ---------------------- | ---------------------- |
| Open website           | Availability           |
| Load voting page       | Availability + Latency |
| Cast vote              | Success Rate           |
| View leaderboard       | Availability + Latency |
| Vote counted correctly | Correctness            |


## SLIs

| SLI Category | User Journey | Measurement | Example Metric | Why It Matters |
| ----------------------- | ------------------------------------------------ | --------------------------------------------------- | ------------------------------------------ | ----------------------------------------------------------------------- |
| Availability | User can access the application | Successful requests ÷ total requests | Non-5xx requests / total requests | Measures whether the application is reachable and functioning for users |
| End-to-End Availability (🔜 Awaiting Voting Bot Tooling) | User can reach the application from the Internet | Successful synthetic checks ÷ total checks | `probe_success` | Includes DNS, TLS,  ALB, EKS, Service and Pod failures |
| Latency | Application responds quickly                     | Percentage of requests under latency threshold | p95 request latency < 300ms | Measures responsiveness experienced by users |
| Vote Success | User can submit a vote                           | Successful votes ÷ total vote attempts | `vote_success_total / vote_requests_total` | Measures success of the application's primary business function |
| Vote Latency | Voting completes quickly | Percentage of vote requests under threshold | p95 vote latency < 2s | Measures responsiveness of the most important workflow |
| Leaderboard Freshness  (🔜 Awaiting Telememetry Tooling)  | User sees vote results reflected promptly | Time between vote acceptance and leaderboard update | Leaderboard update delay | Detects lag between backend processing and user-visible results |
| Correctness (🔜 Awaiting Voting Bot Tooling) | Votes are counted accurately |Correct results ÷ total results | Vote count matches displayed leaderboard | Detects data integrity issues that availability metrics cannot catch |


| Priority | SLI                     |
| -------- | ----------------------- |
| 1        | End-to-End Availability |
| 2        | Request Availability    |
| 3        | Request Latency         |
| 4        | Vote Success Rate       |
| 5        | Vote Latency            |
| 6        | Correctness             |
| 7        | Freshness               |

## SLOs

SLOs (Service Level Objective) are reliability targets defined against one or more SLIs, they represent what at good enough looks like a user perspective. They are typically stricter than SLAs, and they are used to set Error Budgets, used as a measure of reliability across multiple business functions, and helps to inform what needs to be prioritised in terms of engineering effort and operational investment.

SLOs are informed by business goals, when converting business goals into SLOs, we ask:

* **Q: Which user journeys are critical?**
* A: For our application, we start my asking "How can this app fail?", user need to be able to access the Web UI, being able to see the voting options availible, being able to cast your vote, and then to see the leaderboard.

* **Q: What does “good enough” look like for those journeys (latency, availability, correctness)?**
* A: A small amount of latency is acceptable provided the application remains responsive, each page should load successfully as close to 100% of the time as possible and a vote should succeed as close to 100% of the time as possible. We also need to determine what counts as an Error is it just 5xx messages from the application? No, user-facing issues may also originate from the load balencer, the Kubernetes platform itself, networking components, or cloud infrastructure. Therefore, these should be included when measuring availability.

* **Q: What trade-offs between cost and reliability are acceptable?**
* A: We certainly want High Availibity, but does connectivity to this applicaton need to be so fast that we have presence in each AWS region, and does this application require a multi-region architecture, or is resilience across multiple Availability Zones sufficient? We expect that most 100% of the userbase will be within the US, however we do want reliability between AWS AZs, so we are prepared to have a K8s nodes across multiple availability zones within our chosen us-west-2 AWS region.

| SLI | SLO | Window | Reasoning |
| ----------------------- | ----------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------- |
| End-to-End Availability (🔜 Awaiting Voting Bot Tooling) | 99.9% successful voting bot checks | Rolling 30-day period | Measures whether users can actually reach the application |
| Request Availability | 99.9% of requests return a successful response | Rolling 30-day period | Core application reliability objective |
| Request Latency | 95% of requests complete within 300ms | Rolling 30-day period | Represents a responsive web application experience |
| Vote Success Rate | 99.9% of vote submissions are processed successfully | Rolling 30-day period | Measures the application's primary business function |
| Vote Latency | 95% of vote submissions complete within 2 seconds | Rolling 30-day period | Users should receive timely feedback when voting |
| Correctness (🔜 Awaiting Voting Bot Tooling) | 99.9% of voting bot vote validation tests pass | Rolling 30-day period | Ensures votes are accurately recorded and displayed |


### Error Budgets

Error budgets are the allowed amount of service unavailibility we are allowed over a window of time. For example, for our 99.9% Service avialibilty SLO, that means we are allowed 0.1% downtime. Over a month we are allowed 43m 12s. 

| Availability SLO | Allowed Downtime (30 Days) |
| ---------------- | -------------------------- |
| 99% | 7h 12m |
| 99.5% | 3h 36m |
| 99.9% | 43m 12s |
| 99.95% | 21m 36s |
| 99.99% | 4m 19s |

Error budgets provide a mechanism for balancing reliability and feature delivery. Error budget is used up by service downtime, and if it runs out, it is expected that there be some change in behavour to reduce risk until the error budget has replenished. That may be pausing Feature Development, or perhaps pushing only critial updates for that time, and reliability work should take priority.

## SLAs

SLAs (Service Level Agreements) are formal commitments to users or customers around service reliability. They are typically less strict than internal SLOs, providing a buffer before a customer facing commitment is breached.

| Metric | SLA |
| ---------------------------- | ------------------------ |
| Service Availability | 99.5% per calendar month |
| Vote Processing Success Rate | 99.0% per calendar month |

This application is operated as a demonstration platform and no commercial guarantees are provided.

## Future evolution

In future, telemetry will be implemented into the Emojivoto application and will be used to add additional SLIs & SLOs.

In future, the Voting Bot can be enhanced to generate synthetic traffic and validate user journeys. This would allow us to test end-to-end availability, latency, and correctness based on real application behaviour rather than individual infrastructure components.

