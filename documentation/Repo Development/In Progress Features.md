# Phase 4 (Final Infra changes)

## Terraform

* There do seem to be conflicts with DNS records when both staging and production are deployed the same time - seem to get created and then disappear. Will require investigation.

## ArgoCD

* Manual approval required in deployment scenario 
* In prod ensure argocd config [syncPolicy: automated: prune: false]

# Phase 5 (Documentation & Monitoring)

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

## R

* Update JT & JD for last 2 positions to tailor more towards. Include IC, PostM etc.

## Final Polish

* Video demoing the environment (what should I cover?)
* Add UI of Prometheus Dashboards App to Readme
* Update Monitoring Strategy documentation with Dashboard screenshots
* Photos on site (x4 P and x1 Headshot)