# workhorse-aws-terraform project plan

# Phase 1 (Dev and POC)

## K8s

* ~K8S cluster composed of emojivoto~
* ~Create only a Dev enviroment (with separate Staging & Prod Deployments in later phases)~
* ~Deploy cert-manager via helm to web frontend traffic~
* ~Implement an ingress-nginx via helm~
* ~Implement an ingress for argocd UI & CLI~
* ~Use a basic secret, using different secrects for each of dev~

## Terraform

* ~Set up a bucket to store terraform state file~ 
* ~Use modules to create template to be deployed into staging~
* ~Deploy EKS cluster~

## CD

* ~Deploy ArgoCD in K8s and configure Applicaton & Project to pull and deploy within cluster manually~
* ~Set repo containing delaratve k8s files as a source (or use HELM if we decided to go that route for the k8s deployment)~
* ~Deploy app config using declarative files~
* ~Configure Auto-Pruning & Self-Healing sync strategies~
* ~Need to decide where ArgoCD should live. Can be on my local minikube at first, but may be worth investigating setting up on Oracle Cloud Free Tier in k3s it deploy to production~
* ~Deploy Bitnami Sealed Secrets and test storing dev creds encrypted~

## Prometheus

* ~Deploy using helm via argocd in Dev environment~
* ~Configure an ingress for prometheus and a TLS certificate in Dev Environment~
* ~Configure Prometheus to monitor each service as part of the emojivoto application~
* ~Configure Prometheus to scrape Application Endpoints~
* ~Create Dashboards using default Prometheus data~
* ~Deploy via Helm and create Ingress for Dev Env and configure TLS web cert for https access~
* Service Discovery K8s

## Grafana

* ~Create Dashboard for Votes within Application (Fun for testing)~
  - ~Total votes~
  - ~Votes/sec~
  - ~Top 10 Leaderboard~
  - ~Vote Distribution Pie Chart~
* ~Create Dashboard for issues within Application~
  - ~P95 Latency ("95% of requests completed in under X ms")~
  - ~P99 Latency~
  - ~Error Rate~
  - ~gRPC Error Rate~
  - ~Errors By Status Code~
  - ~Requests/sec~
  - ~Goroutines~
* ~Create Dashboard for node health (compatible with Minikube & EKS)~
  - ~The default ones are, ok~

## Log Aggregation (Loki)

* ~Set up centralised logging service (Loki) in Dev environments~

# Phase 2 (Staging and Cloud POC)

## K8s

* ~Create Staging Deployments~
* ~Following terraform deployment, expose to the internet~
* Set up encrypt-at-rest for Staging and Prod Secret
* ~Set up Persistent volumes using EKS EBS CSI, use Helm chart to deploy - noting that additional IAM access is required first~
* Configure Horizontal Pod Autoscaling (HPA) based on load

## EKS

* ~Enable Cloudwatch logging (potentially add Agent and ADOT to cluster)~

## CI
* Use runner to validate that k8s config in the repo is valid (YAML syntax is fine initially) 
* Use runner to validate that terraform config in the repo is valid (`terraform validate` command`)
* Use runner to validate that prometheus config in the repo is valid (`promtool check config` command`)

## CD

* ~Deploy new cloud-based argocd instance to manage deployment of staging and prod~
* ~Deploy Bitnami Sealed Secrets and store Staging & Production creds encrypted~

## Prometheus/Grafana/Terraform

* ~Deploy using helm via argocd in Staging & Prod environment~
* ~AWS Cloud Exporter - Export AWS & EKS Metrics to Prometheus~
* ~AWS Load Balancer Controller metrics - Export to Prometheus~
* ~Dashboards for the above new metrics~
* ~Dashboard for EKS Cluster Health~
  - ~Node Ready~
  - ~Node CPU~
  - `Node Memory~
  - ~Pod Restarts~
  - ~Pod Pending~
  - ~Pod OOM Kills~
  - ~API Server Availability~
* ~Dashboard for EKS Cluster Health~
  - ~Systemd Errors~
  - ~Kubelet Errors~
  - ~Kernel Errors~
  - ~Audit Events~

## Loki

* ~Logs from nodes into Loki~
* ~EKS Control Plane Logging - Export EKS Control plane logs into Cloudwatch~
* ~CloudWatch Logging - Export CloudWatch logs to Loki using Lambda Promtail. Include logs for:~
  - ~EKS~
  - ~VPC flow logs~
  - ~Route53 Resolver Logs~
  - ~CloudTrail~

# Phase 3 (Production & Auxilary Cloud Features)

## Terraform

* Use modules to create template to be deployed into Production

## Prometheus

* Deploy using helm via argocd in Prod environment
* Add monitoring for K8s architecture in EKS
* Create Ingress for Staging & Prod Envs and configure TLS web cert for https access
* Add checks for certificate expirely for all the new certs
* When it comes to permissions/authorisation, ensure that you note that `AlwaysAllow` is enabled by default and that we mush ensure this is changes before pushing to prod 
* Service Discovery for AWS [ec2] (Staging and Prod envs). Will need to create service IAM user via terraform 

## Loki & Alertmanager

* Create useful Loki log labels. loki.relabel to promote the below to Loki labels.
  - _SYSTEMD_UNIT
  - _HOSTNAME
  - _TRANSPORT
* After the above Set up Node alerts for
  - Kubelet problems: `{job="systemd-journal"} |= "Failed"`
  - CNI failures: `{job="aws-routed-eni"} |= "error"`
  - OOM kills: `{job="systemd-journal"} |= "Out of memory"`
  - And more...

# Phase 4 (Documentation & Resiliancy Planning)

## Terraform

* Implement across multiple AWS Regions (as part of SLI/SLO resiliancy plan)
* Implement across multiple AZs (as pary of SLI/SLO planning)

## Chaos Engineering

* [TBD in conjunction with resiliancy documentation]

# Phase 5 (Documentation)

## Architecture

* High Level Diagram (EKS, Namespaces, services, Alloy, Loki, Prometheus, Grafana)
* Deployment Model (ArgoCd Gitops + Github, Terraform, Helm)
* Networking (Load Balancers, Ingress, Pod Networking) & Security (IAM for Service accounts, Sealed Secets)
* Storage (EBS, S3)

## Design decisions

* Why did you chose
  - EKS over k3s/minikube
  - ArgoCD + GitOps over kubectl apply
  - Prometheus + Loki over ELK or Datadog
  - Terraform instead of Cloudformation
* Each decision Including
  - The Problem
  - Options considered
  - Tradeoffs
  - FinalChoice
  - Why it fits principles (simplicity, reliability, cost, observability)

### EKS 

* Using one VPC per cluster (one for staging, one for prod) 
* Warm ENIs/IP addresses (for scaling & redundancy)
* could use prefix delegation and IPv6

## Runbooks

* If X happens, follow these steps
  - Pod CrashLoopBackOff
  - ArgoCD Out of Sync
  - Loki ingestion failing
  - Prometheus scraping failures
* Each must include:
  - Symptoms
  - How to diagnose
  - Root cause patterns
  - Remediation Steps
  - Preventions / Long term fixes

## Monitoring Strategy

* What to Monitor & why
* How alerts are structured
* SLIs/SLOs
* How logs and Metrics connect
* Dashboards I've built
  - Purpose
  - Key panels
  - Why these metrics matter
  - How to interpret anomolies 

## SOPs

* Deploying New version of ArgoCD
* Deploying New version of Helm Charts
* Deploying New version of App
* Rotating Secrets via Sealed Secrets
* Upgrading EKS versions

## Case Studies

* Choose 2:
  - Loki Ingestion Outage
  - Redis latency spike affecting emojivoto
  - NOde OOMKill due to misconfigured limits
  - ALB routing misconfiguartion
* Include:
  - Symptoms
  - Investigation
  - Root Cause
  - Fix 
  - Preventions
  - What I learned

## Postmortem

* Use google-style template


## Misc Documentation

* Talk about how I will be storing some credentials for Production in GitLab (since this is just ) but acknowledge that should be using a Centralised External Secret Store like HashiCorp Vault or AWS Secrets Manager
* Increarse pod replicas (as part of SLI/SLO resiliancy plan)
* How to upgrade EKS cluster (note that EKS is only supported for 14 months)


# Phase X (Future Plans)

## K8s

* Build a HA Setup
* Utilise pod identity if I plan on using a service account within AWS
* Use different sizes of node and use Taints/Tolerations and Affinities to get pods onto specific nodes - keep dev nodes on minikube and staging/prod on cloud nodes. 
* Implement Calico CNI in & set up Network Polices between pods, separating by tiers (Platform, Security & Application)
* Setting up encrypt-at-rest for staging and production envs
* Use an example of RBAC
* Generate Admin cert for administration for Staging & Pro environments

## Prometheus

* Set up alerting using PrometheusRules
* Set up remote Read and Write to save space and back up metrics data  
* Monitor ArgoCD and App deployments 
* In Dev environment enabled metrics-server on minikube and configure dev env prometheus to use it
* Monitor ArgoCD though Prometheus

## Grafana

* Add Grafana dashboard(s) for ArgoCD

## Loki

* LokiRuler - add alerts for
  - Alert when a namespace logs > X errors per min
  - Alert when service logs panic
  - Alert when no logs from Alloy

## CD 

* Change package visibility on personal github to make them private and configure k8s to auth using PATs

## Tempo (OpenTelemetry)

* Deploy Tempo Helm, (updating Alloy to collect traces) add tempo to grafana and instrument emojo-voto to use OpenTelemetry

## Documentation

* Cost Analysis
* DR Plan

# Not relevent

## K8s

* [More of a Devops thing] Maybe edit WebApp container to customise, but always stays up to date? (Might be best to use a "command:" in the Pod yaml to achieve this rather than a custom container image with a Dockerfile
* [Trivial to set up and not relevelent to role] Separate users for each of the dev/staging/prod enviroments that have access to only their namespace
* [Not required since I'll be using Helm elsewhere in the project] Maybe use Helm? It might be wiser to do this later in the project, but it might also be a requirement for the deployment pipeline to work. Things to template:
  - Container Images
  - Number of Replcias
  - Ports served
* Role Based access control for each of these users & a Dev role
* Build a custom controller in GO

## Terraform

* Set up dynamoDB table to track state locking - not required in the latest version of terraform state files

## CD

* Create a webhook in the git repo to reach out to ArgoCD to alert when there is new config - used to reduse latency in deployment, not super relevant to this project

## EKS

* AWS Managed Prometheus and AWS Managed Grafana - very cool and gathers additional AWS native information, but not super relevant for this project

