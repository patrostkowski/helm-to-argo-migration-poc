# helm-to-argo-migration-poc

## https://www.aviator.co/blog/how-to-onboard-an-existing-helm-application-in-argocd/

## https://argo-cd.readthedocs.io/en/stable/operator-manual/high_availability/


helm upgrade --install -n argocd --create-namespace argocd argo/argo-cd --set "global.image.tag=v2.6.6" --set "setver.extraArgs='--insecure'" --set "server.disable.auth=true"