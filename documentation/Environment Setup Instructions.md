# Environment Setup Instructions

## General 

### Creating S3 Bucket for Staging/Production State File

* Create the bucket with:
```
aws s3 mb s3://workhorse-terraform-state --region us-west-2
```
### How to regenerate and reconfigure PAT got github repo when it expires

* [TBD]

## Dev

### Install Minikube & ArgoCD on your local devoce

* Install Minikube via CLI
```
brew install minikube
```
* Start Minikube with:
```
minikube start
```
* Switch to Minikube K8s context (if required):
```
kubectl config use-context 
```
* Install ArgoCD Helm Repo:
```
helm repo add argo https://argoproj.github.io/argo-helm 
helm repo update
```
* Install ArgoCD Helm Chart manually
```
helm install argocd argocd/argo-cd --namespace argocd -f workhorse/gitops/dev/root/app-of-apps.yaml
``` 
* Apply app-of-apps.yaml
```
kubectl apply -f workhorse/gitops/dev/root/app-of-apps.yaml
```
* Get initial Admin password ArgoCD 
```
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
``` 
* Use minikube's service funtion to access UI
```
minikube service argocd-server -n argocd
```
Then 
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


# Environment Destory Instructions - Staging & Production

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

