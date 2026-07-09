# Environment Setup Instructions

## General 

### Pulling Repo to local

* Be sure to use the `--recurse-submodules` flag. Run the command:
```
git clone --recurse-submodules https://github.com/jresmith/workhorse-aws-terraform.git
``` 

### Creating S3 Bucket for Staging/Production State File

* Create the bucket with:
```
aws s3 mb s3://workhorse-terraform-state --region us-west-2
```
### How to regenerate and reconfigure PAT got github repo when it expires

* [TBD]

## Dev

### Install Minikube & ArgoCD on your local device

* Ensure Docker has at least x4 CPUs and 8GB Memory availible 

* Install Minikube via CLI
```
brew install minikube
```
* Start Minikube with:
```
minikube start --memory=8192 --cpus=4
```
* Switch to Minikube K8s context (if required):
```
kubectl config use-context minikube
```
* Install ArgoCD Helm Repo:
```
helm repo add argo https://argoproj.github.io/argo-helm 
helm repo update
```
* Install ArgoCD Helm Chart manually
```
helm install argocd argocd/argo-cd --namespace argocd --create-namespace -f workhorse/gitops/dev/root/app-of-apps.yaml
``` 
* Apply app-of-apps.yaml
```
kubectl apply -f workhorse/gitops/dev/root/app-of-apps.yaml
```
* Add Git repo PAT token as a secret
```
kubectl apply -f workhorse/gitops/repos/repos.yaml 
```

* Get initial Admin password ArgoCD 
```
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
``` 
* Use minikube's service funtion to access ingress
```
minikube service ingress-nginx-controller -n ingress-nginx
```
Make note of the port used for forwarding, in this case, 61513 for https:

```
🔗  Starting tunnel for service ingress-nginx-controller.
┌───────────────┬──────────────────────────┬─────────────┬────────────────────────┐
│   NAMESPACE   │           NAME           │ TARGET PORT │          URL           │
├───────────────┼──────────────────────────┼─────────────┼────────────────────────┤
│ ingress-nginx │ ingress-nginx-controller │             │ http://127.0.0.1:61512 │
│               │                          │             │ http://127.0.0.1:61513 │
└───────────────┴──────────────────────────┴─────────────┴────────────────────────┘

```
* Edit /etc/hosts (or local DNS lookup) to direct the below FQDNs to localhost:
  * argocd.dev.local
  * boutique.dev.local
  * prometheus.dev.local
  * alertmanager.dev.local
  * grafana.dev.local
  * loki.dev.local

* Navigate to `https://argocd.dev.local:[forwarded port]` in your browser. In the example above `https://argocd.dev.local:61513`
* Log into us  with username `admin` and the password retrieved above

### Access ArgoCD via CLI on your local device (Dev Environment)

* [Install ArgoCD CLI Client - Instuctions TBD]
* Log in using the same FQDN & Port noted above:
```
argocd login argocd.dev.local:[forwarded port]
```

### Access Grafana via CLI on your local device (Dev Environment)

* Navigate to `https://grafana.dev.local:[forwarded port]` in your browser. In the example above `https://grafana.dev.local:61513`
* Login with username/password `admin/admin`

## Staging

### Set up AWS Access for Terraform

* Log into AWS Console
* IAM > IAM users > Create User > ["workhorse-staging"] > Attach Policys directly > Check 'AdministratorAccess'
* IAM > IAM users > ["workhorse-staging"] > Security Credentials > Create Access Key
* Choose "Command Line Interface" and note the Access Key and Security Key
* Configure local aws profile using:
`aws configure --profile workhorse-staging` 

### Connect to EKS in Staging Environment

* Configure kubectl 
```
aws eks update-kubeconfig \
  --name workhorse-staging-eks \
  --region us-west-2 \
  --profile workhorse-staging
``` 

## Production


# Environment Destory Instructions - Staging & Production Terraform

### terraform destory

* Run `terraform destroy`
* You may need to manually delete the Node Group before terraform destroy works. Run this command to get the list of active Node Groups:
```
aws eks list-nodegroups --cluster-name workhorse-staging-eks --region us-west-2
```
* Run this command to delete the` remaining Node Group
```
aws eks delete-nodegroup  --nodegroup-name <Node Group Name> --region us-west-2
```
* It can take up to 30 mins for the Node Group to delete successfully
* Rerun `terraform destroy`

