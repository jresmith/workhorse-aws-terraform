# workhorse-aws-terraform
A project to act as and AWS refresher and Terraform deployment repo


# Phase 1 

## K8s

* K8S cluster composed of x1 Web App, Exposed to the Internet
* Cert-Manager to issue self-signed cert
* Separate Dev, Staging & Prod Deployments
* Use DaemonSets to deploy Monitoring (Prometheus) and Logging (FluentD?) pods to each node
* Use a basic secret

### k8s maybes
* Maybe use Helm?
* Maybe edit WebApp container to customise, but always stays up to date? (Might be best to use a "command:" in the Pod yaml to achieve this rather than a custom container image with a Dockerfile
* Maybe I deploy the enter architecture, but with no resiliance? x1 Frontend, x1 Worker, No backups etc. Then I can document how I made it resilant? 

## Terraform

* Static (No varibles), or maybe just a couple

## CI/CD

* Configure Deployment Pipeline using ArgoCD

## Prometheus

* Monitor Application with basic checks

# Phase 2

## K8s

* A implement a worker
* Introduce multiple fromtends and a LoadBalencer
* Implement across multiple AZs 

### k8s maybes
  
* Use different sizes of node and use Taints/Tolerations and Affinities to get pods onto specific nodes

## Terraform

* Implement more widespread use of Varibles

## Prometheus

* Monitor new parts of Application with more advanced check and dashboards 

# Phase 3

## K8s

* A implement a database alongside a cluster IP
* Implement across multiple AWS Regions

## Prometheus

* Monitor new parts of Application
