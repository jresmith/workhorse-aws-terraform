# Phase 4 (Final Infra changes)

## ArgoCD

* Manual approval required in deployment scenario 
* In prod ensure argocd config [syncPolicy: automated: prune: false]

## Prometheus

* New Dashboard based on SLIs. Stat Panel at the top, more detail below.
* New Dashboard based on SLOs. Colour code Green, Yellow (close to violation) & Red
* New Dashboard based on SLAs. Show how much Error Budget has been consumed
* New Dashboard Level 1: Service Health OverView. "Is Everything Okay?"
* New Dashboard Executive Dashboard 

# Phase 5 (Documentation & Monitoring)

## Final Polish

* Main Video demoing the environment:
	- Infra Diagram
	- Walk through AWS Console
	- Grafana dashboards
	- App working End-to-end
* Add UI of Prometheus Dashboards App to Readme
* Update Monitoring Strategy documentation with Dashboard screenshots
* Photos on site (x4 P and x1 Headshot)