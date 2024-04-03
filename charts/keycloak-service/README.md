# keycloak-service
Helm chart for installing the keycloak-service into a Kubernetes cluster. It will deploy Keycloak Operator first, then 
deploy Keycloak cluster with a Postgres database through the Operator.

## Chart Values

| Value               | Description
|---------------------|---
| `instances`         | The number of keycloak pods to be running.
| `requestCPU`        | The value of the `spec.template.spec.containers.resources.requests.cpu` property for keycloak pod.
| `requestMemory`     | The value of the `spec.template.spec.containers.resources.requests.memory` property for keycloak pod.
| `limitCPU`          | The value of the `spec.template.spec.containers.resources.limits.cpu` property for keycloak pod.
| `limitMemory`       | The value of the `spec.template.spec.containers.resources.limits.cpu` property for keycloak pod.
| `ingress.host`      | Ingress host of keycloak.<host> to route to Keycloak from external. 

## Install
Helm install
```
helm install keycloak <path-to-chart> -n <namespace> --set ingress.host=<host:port>
```
Once all pods are up and ready, open the url http://keycloak.<host:port>/auth for Keycloak console. Next, you need to create 'Precisely' realm by importing the realm-spatial.json in deployments folder.

## Notes
The admin credentials is auto-generated, use the following cmds to find it out after install,
```
$ kubectl -n <namespace> get secret credential-spatial-keycloak -o=jsonpath="{.data.ADMIN_USERNAME"}" | base64 -d
$ kubectl -n <namespace> get secret credential-spatial-keycloak -o=jsonpath="{.data.ADMIN_PASSWORD}" | base64 -d
```

The chart will create CRDs for Keycloak Operator. These CRDs will not be removed when unistall the chart. The CRDs can be 
removed completely using the following cmds but since the CRDs are cluster wide resources, ensure there's no other Operators 
running in any namespaces before removing.

```
$ kubectl patch crd/keycloakrealms.keycloak.org -p '{"metadata":{"finalizers":[]}}' --type=merge
$ kubectl delete -f helm/charts/keycloak-service/crds
```

It may hang if removing realm resources after the keycloak was removed. Use the following to resolve,
```
$ kubectl patch keycloakrealm/precisely-realm  -p '{"metadata":{"finalizers":[]}}' --type=merge -n keycloak
```
