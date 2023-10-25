```
patrostkowski in ~/Patryk/programming/helm-to-argo-migration-poc/kubernetes/raw on main λ helm install kafka -n kafka bitnami/kafka --version 26.2.0 --values kafka.yaml

patrostkowski in ~/Patryk/programming/helm-to-argo-migration-poc/kubernetes/raw on main λ cat kafka.yaml                                      
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kafka
  namespace: argocd
spec:
  project: default
  destination:
    namespace: kafka  #update namespace name if you wish
    name: in-cluster   #update cluster name if its different
  source:
    repoURL: https://github.com/patrostkowski/helm-to-argo-migration-poc.git
    targetRevision: "main"
    path: helm/releases/kafka
    helm:
      releaseName: kafka
      valueFiles:
        - kafka.yaml
  syncPolicy:
    automated:
      prune: false
      selfHeal: false
patrostkowski in ~/Patryk/programming/helm-to-argo-migration-poc/kubernetes/raw on main λ k apply -f kafka.yaml

patrostkowski in ~/Patryk/programming/helm-to-argo-migration-poc/kubernetes/raw on main λ helm list -A
NAME  	NAMESPACE	REVISION	UPDATED                              	STATUS  	CHART          	APP VERSION
argocd	argocd   	1       	2023-10-25 22:19:12.150865 +0200 CEST	deployed	argo-cd-5.16.14	v2.5.5     
kafka 	kafka    	1       	2023-10-25 23:44:17.79618 +0200 CEST 	deployed	kafka-26.2.0   	3.6.0      
patrostkowski in ~/Patryk/programming/helm-to-argo-migration-poc/kubernetes/raw on main λ k delete secret -n kafka sh.helm.release.v1.kafka.v1 
secret "sh.helm.release.v1.kafka.v1" deleted
patrostkowski in ~/Patryk/programming/helm-to-argo-migration-poc/kubernetes/raw on main λ helm list -A                                        
NAME  	NAMESPACE	REVISION	UPDATED                              	STATUS  	CHART          	APP VERSION
argocd	argocd   	1       	2023-10-25 22:19:12.150865 +0200 CEST	deployed	argo-cd-5.16.14	v2.5.5
```