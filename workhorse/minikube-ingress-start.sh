#!/bin/bash

set -e pipefail

TMPFILE=$(mktemp)

links_to_be_opened=(
    "argocd.dev.local"
    "emojivoto.dev.local"
    "prometheus.dev.local"
    "alertmanager.dev.local"
    "grafana.dev.local"
)

minikube service ingress-nginx-controller -n ingress-nginx --url | tee "$TMPFILE" &

# Set PID to variable to be used 
PID=$!

# Wait for the localhost HTTPS URL to appear
while true; do
	# get the last local URL that contains localhost
    URL=$(grep -oE 'http://127\.0\.0\.1:[0-9]+' "$TMPFILE" | tail -n1)
    # Once URL has been defined
    if [[ -n "$URL" ]]; then
    	# get forwarded HTTPS port
        PORT=$(echo "$URL" | awk -F':' '{ print $3 }')
        # Loop thought and open each link
        for site in "${links_to_be_opened[@]}"; do
        	open "https://${site}:${PORT}/"
		done
		# end loop once urls have been opened
		break

    fi
    # Wait in case URL has not yet been output
    sleep 1
done

argocdadminpwd=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD Admin Password is: ${argocdadminpwd}"

#Using PID varible set earlier, keep script running until minikube service command has ended
wait "$PID"