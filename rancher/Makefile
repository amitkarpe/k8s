install_rancher:
	ns=cattle-system
	kubectl create namespace $$ns
	kubectl config set-context --current --namespace $$ns
	# Ingress
	helm install rancher-nginx stable/nginx-ingress --set rbac.create=true
	kubectl get services -o wide rancher-nginx-nginx-ingress 
	kubectl get services -o wide rancher-nginx-nginx-ingress -o json | jq -r '.status.loadBalancer.ingress[].hostname'
	# Cert Manager - https://cert-manager.io/docs/installation/kubernetes/ |  Kubernetes 1.15+
	kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.0/cert-manager.crds.yaml
	helm install cert-manager jetstack/cert-manager --version v0.14.0
	# Metrics
	helm install metrics stable/metrics-server; sleep 60; kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"; sleep 60; kubectl top node
	# Rancher
	ELB=$$(kubectl get services -o wide rancher-nginx-nginx-ingress -o json | jq -r '.status.loadBalancer.ingress[].hostname'); echo $$ELB
	helm install rancher rancher-stable/rancher --set hostname=$$ELB
		

