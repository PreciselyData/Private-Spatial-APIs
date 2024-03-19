# Enabling security AKS - AuthN/AuthZ

A Keycloak (18.0.0+) is used for authentication and authorization. If
you have an external Keycloak instance that can be accessed from inside
the AKS cluster, then collect the issuer url for further service config,
otherwise, you can deploy a keycloak service into the AKS cluster.


### Deploy a Keycloak service into the AKS cluster.

Create a namespace for the Keycloak

```shell
kubectl create ns keycloak
```

Identify the external load balancer host to expose the Keycloak
Management Console UI

```shell
kubectl get svc -n ingress-nginx
```
```shell
NAME                                 TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.0.5.175     23.96.127.58   80:31943/TCP,443:32142/TCP   5d16h
ingress-nginx-controller-admission   ClusterIP      10.0.134.147   <none>         443/TCP                      5d16h
```

looking for the EXTERNAL-IP in the output

e.g. 23.96.127.58 → 23-96-127-58.nip.io


### Deploy keycloak by helm chart

```
helm install keycloak spatial/keycloak-service --version 1.0.0 -n keycloak --set ingress.host=23-96-127-58.nip.io
```
```shell
NAME: keycloak
LAST DEPLOYED: Tue Jul 19 12:18:35 2022
NAMESPACE: keycloak
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Spatial Keycloak operator and service are installed in namespace keycloak.

Service Endpoint URL
    http://keycloak.23-96-127-58.nip.io

Admin credentials
    

    also get the credentials from,
    $ kubectl -n keycloak get secret credential-spatial-keycloak -o=jsonpath="{.data.ADMIN_USERNAME}" | base64 -d
    $ kubectl -n keycloak get secret credential-spatial-keycloak -o=jsonpath="{.data.ADMIN_PASSWORD}" | base64 -d

To learn more about the release, try:

    $ helm status keycloak --namespace=keycloak
    $ helm get all keycloak --namespace=keycloak
```

---
**NOTE** Service Endpoint URL displayed contains the namespace which makes the URL invalid. use the URL without namespace

Service Endpoint URL\
http://23-96-127-58.nip.io

---
Wait until keycloak-0 pod in keycloak namespace is up and ready. you can verify by running following command

```shell
kubectl get pod -n keycloak
```

###  Enable ingress class for keycloak

```shell
kubectl -n keycloak annotate ingress keycloak kubernetes.io/ingress.class=nginx
```

### Get admin username

default: `admin`

default username can be found by running following command

```shell
kubectl -n keycloak get secret credential-spatial-keycloak -o=jsonpath="{.data.ADMIN_USERNAME}" | base64 -d
```

###  Get the admin password (e.g. `V4YAGs76OzGMvA==`)

```shell
kubectl -n keycloak get secret credential-spatial-keycloak -o=jsonpath="{.data.ADMIN_PASSWORD}" | base64 -d
```
\
Open a browser and log in to keycloak console with the admin credentials
at \
user EXTERNAL-IP from ingress-nginx to form the URL\
e.g. 23.96.127.58 → 23-96-127-58.nip.io\
[http://23-96-127-58.nip.io/auth/admin](http://23-96-127-58.nip.io/auth/admin)



### Create a realm for spatial services

\
Import `realm-spatial.json` to create the realm.\
`realm-spatial.json` can either be directly downloaded from github: [realm-spatial.json](https://github.com/PreciselyData/SpatialAnalytics/blob/main/deploy/realm-spatial.json) or is located in checked out clone from Shell in directory `SpatialAnalytics/deploy/realm-spatial.json`\
\
In administration console, move cursor over the \'Master\' realm and
click on \'Add realm\'

Select the realm file `realm-spatial.json`, give a name to the new
realm (use all lowercase name, e.g. development) and click the
`Create`.\
\
also see Keycloak document about the Management
Console. [https://www.keycloak.org/docs/latest/server_admin/](https://www.keycloak.org/docs/latest/server_admin/)


Update service config to use the keycloak

```shell
kubectl edit cm spatial-config
```

URL `http://23-96-127-58.nip.io` is formed using the external IP for ingress.

```yaml
oauth2.enabled: "true"
oauth2.issuer-uri: "http://23-96-127-58.nip.io/auth/realms/<your realm name>"
oauth2.client-id: "spatial"
oauth2.client-secret: "fd17bc1d-cefc-41a3-8c50-bb545736caa6"
spring.security.oauth2.resourceserver.jwt.issuer-uri: "http://23-96-127-58.nip.io/auth/realms/<your realm name>"
```


Restart all services to pick up the config

```shell
kubectl rollout restart deployment
```

```shell
kubectl get pod
```

Login to Spatial Manager when all services are ready. Initial password
for admin is `Spatialadmin0`. Also, update the URL based on ingress external IP.


---
**NOTE** Verify Spatial Manager with keycloak

[https://\<external-ip>/SpatialServerManager](https://\<external-ip>/SpatialServerManager)

---

Verify if you can preview a map in Spatial Manager.
\
\
\
NAVIGATION:

- [Getting Started - Spatial Cloud Native: Azure AKS](README.md)
- [Next Step -> Step 8: Spatial Utilities](../spatial-utilities.md)