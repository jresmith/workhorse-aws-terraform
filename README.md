# workhorse-aws-terraform project plan

# Phase 1 

## K8s

* ~K8S cluster composed of Goodle online boutique~
* ~Create only a Dev enviroment (with separate Staging & Prod Deployments in later phases)~
* ~Deploy cert-manager via helm to web frontend traffic~
* ~Implement an ingress-nginx via helm~
* ~Implement an ingress for argocd UI & CLI~
* ~Use a basic secret, using different secrects for each of dev~
* Implement Calico CNI in Dev environment 
* set up Network Polices between pods, separating components, being sure the specify the correct namespace in each policy. Ensure we are allowing DNS to K8s DNS service
* Set up Persistent volumes using EKS EBS CSI, use Helm chart to deploy - noting that additional IAM access is required first

## Terraform

* ~Set up a bucket to store terraform state file~ 
* ~Use modules to create template to be deployed into staging~
* ~Deploy EKS cluster ~

## CD

* ~Deploy ArgoCD in K8s and configure Applicaton & Project to pull and deploy within cluster manually~
* ~Set repo containing delaratve k8s files as a source (or use HELM if we decided to go that route for the k8s deployment)~
* ~Deploy app config using declarative files~
* ~Configure Auto-Pruning & Self-Healing sync strategies~
* ~Need to decide where ArgoCD should live. Can be on my local minikube at first, but may be worth investigating setting up on Oracle Cloud Free Tier in k3s it deploy to production~

## Prometheus

* Deploy using helm via argocd
* In Dev environment enabled metrics-server on minikube and configure dev env prometheus to use it
* Configure reusable credentials for Prometheus' web UI to be deployed via gito ps
* Configure an ingress for proetheus and a TLS certificate
* Monitor Application with basic checks

## Log Aggregation (Loki)

* Set up centralised logging service (Loki) in Dev environments

# Phase 2

## K8s

* Create Staging & Prod Deployments 
* Implement Calico CNI in Staging & Prod environments
* Following terraform deployment, expose to the internet
* Set up encrypt at rest for Staging and Prod Secret
* Create service account for Proetheus monitoring, being sure to manually mount ServiceAccount token using a projected volume (may get done as part of helm)

### k8s maybes
  
* Do I need to use RBAC? Especially when it comes to secrets and separation of staging/production?

## Terraform

* Use modules to create template to be deployed into Production

## CD

* Deploy new cloud-based argocd instance to manage deployment of staging and prod
* Deploy Bitnami Sealed Secrets and store Staging & Production creds encrypted

## CD Maybes

* Create a webhook in the git repo to reach out to ArgoCD to alert when there is new config

## Prometheus

* Monitor Application (no K8s infra) using Service Monitor
* Deploy via Helm and create Ingress for Dev Env and configure TLS web cert fro https access
* Create Dashboards using Prometheus data
* Service Discovery K8s

## Log Aggregation (Loki)

* Set up centralised logging service (Loki) in Staging & Prod environments
* Gather logs with an FileBeat sidecar conatiner and send to Loki
 
# Phase 3

## K8s

* Configure Horizontal Pod Autoscaling (HPA) based on load
* Generate Admin cert for administration
* Use DaemonSets to deploy Monitoring (Prometheus) and Logging (FluentD?) pods to each node (may be done as part of helm)
* Potentially use Fargate for monitoring and logging services

## EKS

* Enable Cloudwatch logging (potentially add Agent and ADOT to cluster)

## Terraform

* Implement across multiple AWS Regions (as part of SLI/SLO resiliancy plan)
* Implement across multiple AZs (as pary of SLI/SLO p lanning)

## Prometheus

* Add monitoring for any new parts of the Application architecture
* More in-depth monitoring using service account on k8s
* Add monitoring for K8s architecture & EKS
* create Ingress for Staging & Prod Envs and configure TLS web cert fro https access
* Add checks for certificate expirely for all the new certs
* When it comes to permissions/authorisation, ensure that you note that `AlwaysAllow` is enabled by default and that we mush ensure this is changes before pushing to prod 
* Service Discovery for AWS [ec2] (Staging and Prod envs). Will need to create service IAM user via terraform 

## CI
* Use runner to validate that k8s config in the repo is valid (YAML syntax is fine initially) 
* Use runner to validate that terraform config in the repo is valid (`terraform validate` command`)
* Use runner to validate that prometheus config in the repo is valid (`promtool check config` command`)

# Phase X

## K8s

* Build a HA Setup
* Utilise pod identity if I plan on using a service account within AWS
* Use different sizes of node and use Taints/Tolerations and Affinities to get pods onto specific nodes - keep dev nodes on minikube and staging/prod on cloud nodes. 

## Prometheus

* Set up alerting using PrometheusRules
* Set up remote Read and Write to save space and back up metrics data  
* Monitor ArgoCD and App deployments 

# Documentation/Runbook

* Talk about how I will be storing some credentials for Production in GitLab (since this is just ) but acknowledge that should be using a Centralised External Secret Store like HashiCorp Vault or AWS Secrets Manager
* Increarse pod replicas (as part of SLI/SLO resiliancy plan)
* How to upgrade EKS cluster (note that EKS is only supported for 14 months)

## Design choices

### EKS 

* Using one VPC per cluster (one for staging, one for prod) 
* Warm ENIs/IP addresses (for scaling & redundancy)
* could use prefix delegation and IPv6

# Prerequisities 

## Local env setup

### k8s App setup

* Increase likeliness and readiness on cartservice service.
* Run:
`kubectl edit deployment cartservice`
* Delete all config under `livenessProbe:` & `readinessProbe:`

### argocd setup 

* Install argocd CLI
* Run `argocd login X.X.X.X:YYYY` and provide argocd creds: user=admin & password (gathered from `kubectl get secrets argocd-initial-admin-secret -n argocd -o yaml`)
* Enable Helm in ArgoCD globally using `kubectl edit configmap argocd-cm -n argocd` and add:
```
data:
  kustomize.buildOptions: "--enable-helm"
```
* then run `kubectl rollout restart deployment argocd-repo-server -n argocd`

# Not relevent

## K8s

* [More of a Devops thing] Maybe edit WebApp container to customise, but always stays up to date? (Might be best to use a "command:" in the Pod yaml to achieve this rather than a custom container image with a Dockerfile
* [Trivial to set up and not relevelent to role] Separate users for each of the dev/staging/prod enviroments that have access to only their namespace
* [Not required since I'll be using Helm elsewhere in the project] Maybe use Helm? It might be wiser to do this later in the project, but it might also be a requirement for the deployment pipeline to work. Things to template:
  * Container Images
  * Number of Replcias
  * Ports served
* Role Based access control for each of these users & a Dev role
* Build a custom controller in GO

## Terraform

* Set up dynamoDB table to track state locking - not required in the latest version of terraform state files

## EKS

* AWS Managed Prometheus and AWS Managed Graphana - very cool and gathers additional AWS native information, but not super relevant for this project

