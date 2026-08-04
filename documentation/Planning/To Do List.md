# Phase 3 (Production & Auxilary Cloud Features)

## K8s

* Configure Horizontal Pod Autoscaling (HPA) based on load

## Terraform

* There do seem to be conflicts with DNS records when both staging and production are deployed the same time - seem to get created and then disappear will require investigation.

## ArgoCD

* Manual approval required in deployment scenario 
* In prod ensure argocd config [syncPolicy: automated: prune: false]

# Phase 4 (Documentation & Resiliancy Planning)

## Terraform

* Implement across multiple AWS Regions (as part of SLI/SLO resiliancy plan)
* Implement across multiple AZs (as pary of SLI/SLO planning)
* Implement Cluster Autoscaler/Karpenter

### EKS 

* Using one VPC per cluster (one for staging, one for prod) 
* Warm ENIs/IP addresses (for scaling & redundancy)
* could use prefix delegation and IPv6

## Prometheus & Alertmanager

* Create an alert for each of the SLOs
* Create burn rate alert based on error budget consumption (over both a long period and a short period of time to catch spikes)
 - Urgent: 100% if Error Budget in 1 hour - Text Alert 
 - High: 25% if Error Budget in 6 hours - Text Alert
 - Medium: 50% if Error Budget in 1 day - Email Alert
 - Low: 75% if Error Budget in 3 days - Ticket 
* Performance degrading by 20% over 24 hours
* Response time is >2x the baseline

## Loki & Alertmanager (in conjunction with resiliancy documentation)

* Create useful Loki log labels. loki.relabel to promote the below to Loki labels.
  - _SYSTEMD_UNIT
  - _HOSTNAME
  - _TRANSPORT
* After the above Set up Node alerts for
  - Kubelet problems: `{job="systemd-journal"} |= "Failed"`
  - CNI failures: `{job="aws-routed-eni"} |= "error"`
  - OOM kills: `{job="systemd-journal"} |= "Out of memory"`
  - And more...
* Add Monitoring for monitoring

# Phase 5 (Documentation)

## Documentation

* Design Decisions documentation
* Architecture documentation
* Architecture Diagrams
* Monitoring Strategy documentation
* Alerting documentation
* x2 Case Studies
* Postmortem
* SLI, SLO & SLA documentation
* x2 Runbooks
* x1 SOP

## Prometheus

* New Dashboard based on SLIs. Stat Panel at the top, more detail below.
* New Dashboard based on SLOs. Colour code Green, Yellow (close to violation) & Red
* New Dashboard based on SLAs. Show how much Error Budget has been consumed
* New Dashboard Level 1: Service Health OverView. "Is Everything Okay?"

