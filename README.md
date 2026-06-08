# workhorse-aws-terraform project plan

# Phase 1 

## K8s

* ~K8S cluster composed of Goodle online boutique~
* Deploy cert-manager via helm to encrypt kube-system traffic
* Cert-Manager to issue certificates for applications
* Create only a Dev enviroment (with separate Staging & Prod Deployments in later phases)
* Use a basic secret, using different secrects for each of dev, staging and prod
* Set up encrypt at rest for Staging and Pod Secret

### k8s maybes
* Maybe use Helm? It might be wiser to do this later in the project, but it might also be a requirement for the deployment pipeline to work. Things to template:
  * Container Images
  * Number of Replcias
  * Ports served
* Maybe edit WebApp container to customise, but always stays up to date? (Might be best to use a "command:" in the Pod yaml to achieve this rather than a custom container image with a Dockerfile
* Maybe I deploy the enter architecture, but with no resiliance? x1 Frontend, x1 Worker, No backups etc. Then I can document how I made it resilant? 
* Separate users for each of the dev/staging/prod enviroments that have access to only their namespace
* Role Based access control for each of these users & a Dev role

## Terraform

* Static (No varibles), or maybe just a couple

## CD

* Deploy ArgoCD in K8s and configure Applicaton & Project to pull and deploy within cluster manually
* Set repo containing delaratve k8s files as a source (or use HELM if we decided to go that route for the k8s deployment)
* Deploy app config using declarative files
* Need to decide where ArgoCD should live. Can be on my locsl minikube at first, but may be worth investigating setting up on Oracle Cloud Free Tier in k3s it deploy to production 
* Configure Auto-Pruning & Self-Healing sync strategies
* Deploy Bitnami Sealed Secrets and store dev creds encrypted


## Prometheus

* Deploy using helm
* Monitor Application with basic checks

# Phase 2

## K8s

* Introduce multiple fromtends and a LoadBalencer
* Create service account for Proetheus monitoring, being sure to manually mount ServiceAccount token using a projected volume.
* Creat Staging & Prod Deployments
* Implement an ingress-nginx via helm
* Following terraform deployment, expose to the internet
* Implement a CNI - Flannel if we want something basic, Calico/Cilium if we want more advanced (policies etc.)


### k8s maybes
  
* Use different sizes of node and use Taints/Tolerations and Affinities to get pods onto specific nodes
* Configure Horizontal Pod Autoscaling (HPA) based on load

## Terraform

* Implement more widespread use of Varibles
* Implement across multiple AZs

## CI

* Use runner to validate that config in the repo is valid (YAML syntax is fine initially) 

### CI Maybes

* Create a webhook in the git repo to reach out to ArgoCD to alert when there is new config

## CD

* Deploy Bitnami Sealed Secrets and store Staging & Production creds encrypted

## Prometheus

* Monitor new parts of Application with more advanced check and dashboards
* More in-depth monitoring using service account on k8s

## SIEM (ELK?)

* Set up centralised logging service (maybe ELK) 
* Gather logs with an FileBeat sidecar conatiner and send to ELK

# Phase 3

## K8s

* A implement a database alongside a cluster IP
* Implement across multiple AWS Regions
* Add TLS Certificates for the kube-system componenets:
  * API server
  * Scheduler
  * etcd
  * Controller manager
  * kube-proxy
  * kubelets
* Also generate CA to Sign these certs
* Generate Admin cert for administration
* Apply Network policies to each component to separate frontned, worker and DBs, being sure the specify the correct namespace in each policy
* Use DaemonSets to deploy Monitoring (Prometheus) and Logging (FluentD?) pods to each node

## Prometheus

* Add monitoring for new parts of the Application architecture
* Add certs for certificate expirely for all the new certs
* When it comes to permissions/authorisation, ensure that you note that `AlwaysAllow` is enabled by default and that we mush ensure this is changes before pushing to prod 

# Documentation

Talk about how I will be storing some credentials for Production in GitLab (since this is just ) but acknowledge that should be using a Centralised External Secret Store like HashiCorp Vault or AWS Secrets Manager

# Phase X

## K8s

* Build a custom controller in GO
* Build a HA Setup

# Prerequisities 

## Local env setup

### argocd setup 

* Install argocd CLI
* Run `argocd login X.X.X.X:YYYY` and provide argocd creds: user=admin & password (gathered from `kubectl get secrets argocd-initial-admin-secret -n argocd -o yaml`)

### k8s App setup

* Increase likeliness and readiness on cartservice service.
* Run:
`kubectl edit deployment cartservice`
* Delete all config under `livenessProbe:` & `readinessProbe:`

