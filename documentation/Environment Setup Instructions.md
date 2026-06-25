# Environment Setup Instructions

## General 

### Creating S3 Bucket for Staging/Production State File

* Create the bucket with:
```
aws s3 mb s3://workhorse-terraform-state --region us-west-2
```


## Dev

### Install Minikube & ArgoCD on your local devoce

* [Install Minikube via CLI] - Instructions to be finalised
* [Install ArgoCD manually via helm] - Instructions to be finalised

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

