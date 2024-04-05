# keycloak standalone
Helm chart to install a keycloak single node instance (v23.0.7) running in dev mode for testing.

## Chart Values

| Value               | Description
|---------------------|---
| `hostname`          | The external hostname for admin-console.
| `adminUser`         | The initial admin username (default 'admin').
| `adminPassword`     | The initial admin password (default 'admin').

## Install
Helm install
```
helm install keycloak keycloak-standalone -n keycloak --create-namespace --set hostname=<ingress external ip> 
```
Once all pods are up and ready, open the url http://<ingress external ip>/auth for Keycloak admin-console. 

