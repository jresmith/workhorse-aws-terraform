# Phase 3 (Production & Auxilary Cloud Features)

## K8s

* Implement liveness and readiness probes(?)

## ArgoCD

* Manual approval required in deployment scenario 
* In prod ensure argocd config [syncPolicy: automated: prune: false]

# Phase 4 (Documentation & Resiliancy Planning)

## Terraform

* There do seem to be conflicts with DNS records when both staging and production are deployed the same time - seem to get created and then disappear. Will require investigation.

# Phase 5 (Documentation)

## Documentation

* x2 Case Studies
* Postmortem
* x2 Runbooks


## Prometheus

* New Dashboard based on SLIs. Stat Panel at the top, more detail below.
* New Dashboard based on SLOs. Colour code Green, Yellow (close to violation) & Red
* New Dashboard based on SLAs. Show how much Error Budget has been consumed
* New Dashboard Level 1: Service Health OverView. "Is Everything Okay?"
* New Dashboard Executive Dashboard 

## Final Polish

* Video demoing the environment
* Add UI of Prometheus Dashboards App to Readme
* Update Monitoring Strategy documentation with Dashboard screenshots
