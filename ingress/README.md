# Demo for Ingress

Source code : https://github.com/amitkarpe/k8s
Reference: [Set up Ingress on Minikube with the NGINX Ingress Controller](https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/)

Create web deployment using image hello-app:1.0
```
kubectl run web --image=gcr.io/google-samples/hello-app:1.0 --port=8080
```

Create web service using web deployment
```
kubectl expose deployment web --target-port=8080 --type=NodePort
```

Create host based ingress 
```
kubectl apply -f ingress.yaml
```

Open URL for `web service`:
```
curl $(minikube service web --url -n ingress)
```

Create one more web deployment using version 2.0 image 
```
kubectl run web2 --image=gcr.io/google-samples/hello-app:2.0 --port=8080
```

Create web service using `web2` deployment
```
kubectl expose deployment web2 --target-port=8080 --type=NodePort
```

Open URL for `web2 service`:
```
curl $(minikube service web2 --url -n ingress)
```

Output from curl, while accessing ingress endpoints:
```
(⎈ |minikube:ingress) k8s/ingress   master  curl hello-world.info
Hello, world!
Version: 1.0.0
Hostname: web-9bbd7b488-k26f6
(⎈ |minikube:ingress) k8s/ingress   master  curl hello-world.info/v2
Hello, world!
Version: 2.0.0
Hostname: web2-74cf4946cc-69sdv
```
