# AWS

| Command | Description |
| aws configure --profile workhorse-staging | Configure Access Key and Secret Key for deployment to AWS Staging Environment |
| aws configure --profile workhorse-production | Configure Access Key and Secret Key for deployment to AWS Production Environment |


# K8s

| Command | Description |
| minikube service list | List services in minikube |
| minikube service ingress-nginx-controller -n ingress-nginx | Connect to services forwarded by ingress in minikube |
| kubectl port-forward svc/argocd-server 8080:80 -n argocd | Port-forwarding to ArgoCD Service to access UI in absence of Ingress |

