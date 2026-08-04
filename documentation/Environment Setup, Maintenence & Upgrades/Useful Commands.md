# AWS

| Command | Description |
| --- | --- |
| aws configure --profile workhorse-staging | Configure Access Key and Secret Key for deployment to AWS Staging Environment |
| aws configure --profile workhorse-production | Configure Access Key and Secret Key for deployment to AWS Production Environment |


# K8s

| Command | Description |
| --- | --- |
| minikube service list | List services in minikube |
| minikube service ingress-nginx-controller -n ingress-nginx | Connect to services forwarded by ingress in minikube |
| kubectl port-forward svc/argocd-server 8080:80 -n argocd | Port-forwarding to ArgoCD Service to access UI in absence of Ingress |
| kubectl rollout restart deployment kube-prometheus-stack-operator -n monitoring | Restart may be required are inital CRD installs for Prometheus |
| kubeseal --cert workhorse/gitops/addons/sealed-secrets/public-certs/dev.crt --format yaml < workhorse/gitops/cluster/dev/argocd/config/repo-pat.yaml > workhorse/gitops/cluster/dev/argocd/config/repo-pat-sealed.yaml | How to seal (encrypt) k8s secret using Dev Env Public key |