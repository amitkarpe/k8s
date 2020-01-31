Source Code: https://github.com/GoogleCloudPlatform/cloud-code-samples/tree/master/nodejs/nodejs-guestbook

Using Skaffold:

```
$ skaffold dev  

Listing files to watch...
 - nodejs-guestbook-backend
 - nodejs-guestbook-frontend
Generating tags...
 - nodejs-guestbook-backend -> nodejs-guestbook-backend:latest
 - nodejs-guestbook-frontend -> nodejs-guestbook-frontend:latest
Checking cache...
 - nodejs-guestbook-backend: Not found. Building
 - nodejs-guestbook-frontend: Not found. Building
Found [minikube] context, using local docker daemon.
Building [nodejs-guestbook-backend]...

...

Tags used in deployment:
 - nodejs-guestbook-backend -> nodejs-guestbook-backend:25097f3e6718840f8ea265fa9ff063981083982dd6eb0a2933548a3cd0f8ea75
 - nodejs-guestbook-frontend -> nodejs-guestbook-frontend:bc2a3e6e3ca677eff3d5e98a62b74804547692728e7f220ae13d878957d071e9
   local images can't be referenced by digest. They are tagged and referenced by a unique ID instead
Starting deploy...
 - deployment.apps/nodejs-guestbook-backend created
 - service/nodejs-guestbook-backend created
 - deployment.apps/nodejs-guestbook-frontend created
 - service/nodejs-guestbook-frontend created
 - deployment.apps/nodejs-guestbook-mongodb created
 - service/nodejs-guestbook-mongodb created
Watching for changes...
[nodejs-guestbook-frontend-5cf5d8f84-cndn6 frontend] Debugger listening on ws://127.0.0.1:9229/cc4c0a4d-c6cc-4f93-ae84-4191f4d71c49
[nodejs-guestbook-frontend-5cf5d8f84-cndn6 frontend] For help see https://nodejs.org/en/docs/inspector
[nodejs-guestbook-frontend-5cf5d8f84-cndn6 frontend] App listening on port 8080
[nodejs-guestbook-frontend-5cf5d8f84-cndn6 frontend] Press Ctrl+C to quit.

```

Create Ingress

```
tee ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1beta1 # for versions before 1.14 use extensions/v1beta1
kind: Ingress
metadata:
  name: guestbook
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
  - host: devlocal-frontenddb.gpls.pro
    http:
      paths:
      - path: /
        backend:
          serviceName: nodejs-guestbook-frontend
          servicePort: 80
EOF
kubectl apply -f ingress.yaml
```

Review and test the ingress

```

$ kubectl describe ingress guestbook
Name:             guestbook
Namespace:        guestbook
Address:          192.168.64.7
Default backend:  default-http-backend:80 (<none>)
Rules:
  Host                          Path  Backends
  ----                          ----  --------
  devlocal-frontenddb.gpls.pro
                                /   nodejs-guestbook-frontend:80 (172.17.0.13:8080)
Annotations:
  kubectl.kubernetes.io/last-applied-configuration:  {"apiVersion":"networking.k8s.io/v1beta1","kind":"Ingress","metadata":{"annotations":{"nginx.ingress.kubernetes.io/rewrite-target":"/$1"},"name":"guestbook","namespace":"guestbook"},"spec":{"rules":[{"host":"devlocal-frontenddb.gpls.pro","http":{"paths":[{"backend":{"serviceName":"nodejs-guestbook-frontend","servicePort":80},"path":"/"}]}}]}}

  nginx.ingress.kubernetes.io/rewrite-target:  /$1
Events:
  Type    Reason  Age    From                      Message
  ----    ------  ----   ----                      -------
  Normal  CREATE  6m8s   nginx-ingress-controller  Ingress guestbook/guestbook
  Normal  UPDATE  5m29s  nginx-ingress-controller  Ingress guestbook/guestbook


```

Set hostname and test using `curl`:

```
sudo echo "$(minikube ip) devlocal-frontenddb.gpls.pro" | sudo tee -a /etc/hosts
curl devlocal-frontenddb.gpls.pro
....
....



curl devlocal-frontenddb.gpls.pro -I
HTTP/1.1 200 OK
Server: openresty/1.15.8.2
```


