# Future Plans

## K8s

* Build a HA Setup
* Utilise pod identity if I plan on using a service account within AWS
* Use different sizes of node and use Taints/Tolerations and Affinities to get pods onto specific nodes - keep dev nodes on minikube and staging/prod on cloud nodes. 
* Implement Calico CNI in & set up Network Polices between pods, separating by tiers (Platform, Security & Application)
* Setting up encrypt-at-rest for staging and production envs
* Use an example of RBAC
* Generate Admin cert for administration for Staging & Pro environments

## Terraform

* Set up encrypt-at-rest in EKS for Staging and Prod Secret

## Prometheus

* Set up alerting using PrometheusRules
* Set up remote Read and Write to save space and back up metrics data  
* Monitor ArgoCD and App deployments 
* In Dev environment enabled metrics-server on minikube and configure dev env prometheus to use it
* Monitor ArgoCD though Prometheus
* Service Discovery K8s
* Add checks for certificate expirey for all the new certs

## Grafana

* Add Grafana dashboard(s) for ArgoCD

## Loki

* LokiRuler - add alerts for
  - Alert when a namespace logs > X errors per min
  - Alert when service logs panic
  - Alert when no logs from Alloy

## CD 

* Change package visibility on personal github to make them private and configure k8s to auth using PATs

## Chaos Engineering (in conjunction with resiliancy documentation)

* [TBD]

## Tempo (OpenTelemetry)

* Deploy Tempo Helm, (updating Alloy to collect traces) add tempo to grafana and instrument emojo-voto to use OpenTelemetry

## Documentation

* Cost Analysis
* DR Plan

