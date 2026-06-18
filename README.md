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
* set up Network Polices between pods, separating components, being sure the specify the correct namespace in each policy

## Terraform

* Set up a bucket to store terraform state file (consul may be better)
* Set up, dynamite DB table to track state locking
* Use modules to create template to be deployed into staging & prod
* Static (No varibles), or maybe just a couple
* Deploy a service user that allows me to access aws cli every time a new env is spun up
* Deploy EKS cluster (example setup - https://github.com/kodekloudhub/amazon-elastic-kubernetes-service-course/blob/main/eks/eks.tf)

## CD

* ~Deploy ArgoCD in K8s and configure Applicaton & Project to pull and deploy within cluster manually~
* ~Set repo containing delaratve k8s files as a source (or use HELM if we decided to go that route for the k8s deployment)~
* ~Deploy app config using declarative files~
* ~Configure Auto-Pruning & Self-Healing sync strategies~
* ~Need to decide where ArgoCD should live. Can be on my local minikube at first, but may be worth investigating setting up on Oracle Cloud Free Tier in k3s it deploy to production~

## Prometheus

* Deploy using helm via argocd
* Monitor Application with basic checks

# Phase 2

## K8s

* Create Staging & Prod Deployments 
* Implement Calico CNI in Staging & Prod environments
* Following terraform deployment, expose to the internet
* Set up encrypt at rest for Staging and Prod Secret
* Create service account for Proetheus monitoring, being sure to manually mount ServiceAccount token using a projected volume (may get done as part of helm)

### k8s maybes
  
* Use different sizes of node and use Taints/Tolerations and Affinities to get pods onto specific nodes - keep dev nodes on minikube and staging/prod on cloud nodes

## Terraform

* Implement more widespread use of Varibles

## CI

* Use runner to validate that k8s config in the repo is valid (YAML syntax is fine initially) 
* Use runner to validate that terraform config in the repo is valid (`terraform validate` command`)

### CI Maybes

* Create a webhook in the git repo to reach out to ArgoCD to alert when there is new config

## CD

* Deploy new cloud-based argocd instance to manage deployment of staging and prod
* Deploy Bitnami Sealed Secrets and store Staging & Production creds encrypted

## Prometheus

* Monitor new parts of Application with more advanced check and dashboards
* More in-depth monitoring using service account on k8s

## SIEM (ELK?)

* Set up centralised logging service (maybe ELK) 
* Gather logs with an FileBeat sidecar conatiner and send to ELK

# Phase 3

## K8s

* Configure Horizontal Pod Autoscaling (HPA) based on load
* Generate Admin cert for administration
* Use DaemonSets to deploy Monitoring (Prometheus) and Logging (FluentD?) pods to each node (may be done as part of helm)

## Terraform

* Implement across multiple AWS Regions (as part of SLI/SLO resiliancy plan)
* Implement across multiple AZs (as pary of SLI/SLO planning)

## Prometheus

* Add monitoring for any new parts of the Application architecture
* Add certs for certificate expirely for all the new certs
* When it comes to permissions/authorisation, ensure that you note that `AlwaysAllow` is enabled by default and that we mush ensure this is changes before pushing to prod 

# Phase X

## K8s

* Build a HA Setup

# Documentation

* Talk about how I will be storing some credentials for Production in GitLab (since this is just ) but acknowledge that should be using a Centralised External Secret Store like HashiCorp Vault or AWS Secrets Manager
* Increarse pod replicas (as part of SLI/SLO resiliancy plan)

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



