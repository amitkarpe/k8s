gke:
	kubectl create namespace cattle-system | true
	kubectl create namespace cert-manager | true
	kubectl config set-context --current  --namespace=cattle-system
	helm install rancher-nginx stable/nginx-ingress --set rbac.create=true --set name=rancher-nginx | true
	kubectl --namespace cattle-system get services -o wide rancher-nginx-nginx-ingress-controller -o json | jq -r '.status.loadBalancer.ingress[].hostname'
	helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.14.0 | true
	ELB=$(kubectl get svc -o wide rancher-nginx-nginx-ingress-controller -o json | jq -r '.status.loadBalancer.ingress[].ip')
	helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=$ELB


helm:
	helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
	helm repo add jetstack https://charts.jetstack.io
	helm repo update

create_gke:
	gcloud beta container --project "genuine-energy-264308" clusters create "cluster-1" --zone "asia-southeast1-a" --no-enable-basic-auth --cluster-version "1.14.10-gke.24" --machine-type "n1-standard-1" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-stackdriver-kubernetes --enable-ip-alias --network "projects/genuine-energy-264308/global/networks/default" --subnetwork "projects/genuine-energy-264308/regions/asia-southeast1/subnetworks/default" --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair
