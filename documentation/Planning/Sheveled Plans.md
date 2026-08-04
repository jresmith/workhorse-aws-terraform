# Sheveled Plans

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