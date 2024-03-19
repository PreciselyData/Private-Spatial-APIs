# Prepare and deploy using helm charts


##  Setup Helm registry

In Cloud Shell, replace `<username>` and `<password>` with your helm registry
tokens in the command below.

```shell
helm repo add spatial https://gitlab.com/api/v4/projects/24255413/packages/helm/stable --username <username> --password <password>
```

```shell
helm repo update
helm search repo spatial
```


You should be able to see Spatial-Cloud-Native 1.0.0 version
listed. NAME CHART VERSION\
spatial/spatial-cloud-native 1.0.0


## Create Docker registry secret

\
In Cloud Shell, replace username and password with your Docker image
registry tokens in the command below (if you only got one token, then
use it here as well),

```shell
kubectl create secret docker-registry regcred-gitlab --docker-server=registry.gitlab.com --docker-username=xxxxxx --docker-password=xxxxxx
```

\
To verify,

```shell
kubectl get secret
```
```shell
NAME                            TYPE                                  DATA   AGE
default-token-9fjcj             kubernetes.io/service-account-token   3      46h
regcred-gitlab                  kubernetes.io/dockerconfigjson        1      19h
sh.helm.release.v1.spatial.v1   helm.sh/release.v1                    1      3m24s
```



##  Deploy Spatial-Cloud-Native Helm chart

In Cloud Shell, navigate to `~/SpatialAnalytics/deploy` for deployment files.

```shell
cd ~/SpatialAnalytics/deploy
```
#### Get nginx ingress IP for deployment
```shell
kubectl get svc -n ingress-nginx
```
```shell
NAME                                 TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.0.5.175     23.96.127.58   80:31943/TCP,443:32142/TCP   45h
ingress-nginx-controller-admission   ClusterIP      10.0.134.147   <none>         443/TCP                      45h
```

we will use `EXTERNAL-IP=23.96.127.58` for creating `ingress.host` -> `23-96-127-58.nip.io`

There are two deployment files to choose from that require different amount of resources (CPU and Memory). 
Start from the small one `~/SpatialAnalytics/deploy/gitlab-deployment-small-values.yaml`. 
A production deployment should use `~/SpatialAnalytics/deploy/gitlab-deployment-values.yaml`.

#### Deployment helm using PostgresSQL DB

Edit the `values-jackrabbit-postgres.yaml` to reflect the database
values
```yaml
jackrabbit:
  database:
    id: "postgres"
    url: "jdbc:postgresql://postgis001.postgres.database.azure.com:5432/jackrabbit_db?currentSchema=public"
    user: "jackrabbit_user@postgis001"
    password: "jackrabbit_user"
```

```shell
helm install spatial spatial/spatial-cloud-native --version 1.0.0 \
-f gitlab-deployment-small-values.yaml \
-f values-jackrabbit-postgres.yaml \
--set ingress.host=23-96-127-58.nip.io
```

---
**NOTE** If you encounter `Error: failed to download "spatial/spatial-cloud-native" at version "1.0.0" (hint: running `helm repo update` may help)`

Please try updating your spatial helm using alternate `URL` format before trying to install again:

```shell
helm repo remove spatial
helm repo add spatial https://<username>:<password>@gitlab.com/api/v4/projects/24255413/packages/helm/stable
helm repo update
```

---

#### Deployment helm using SQL DB

Edit the `values-jackrabbit-sqlserver2019-latest.yaml` to reflect the database values. default connection string that is presented by SQL db will not have 
some of the pramaters that are needed for SQL DB.

`selectMethod=cursor`\
`trustServerCertificate=true`

Also, make sure server info matches the server info based on setup. 

```yaml
jackrabbit:
  database:
    id: "mssql"
    url: "jdbc:sqlserver://spatialsqlserver.database.windows.net:1433;selectMethod=cursor;authentication=SqlPassword;Database=spatial;encrypt=false;trustServerCertificate=true"
    user: "spatial@spatialsqlserver"
    password: "Default123"
```

```shell
helm install spatial spatial/spatial-cloud-native --version 1.0.0 \
-f gitlab-deployment-small-values.yaml \
-f values-jackrabbit-sqlserver2019-latest.yaml \
--set ingress.host=23-96-127-58.nip.io
```
---
**NOTE** If you encounter `Error: failed to download "spatial/spatial-cloud-native" at version "1.0.0" (hint: running `helm repo update` may help)`

Please try updating your spatial helm using alternate `URL` format before trying to install again:

```shell
helm repo remove spatial
helm repo add spatial https://<username>:<password>@gitlab.com/api/v4/projects/24255413/packages/helm/stable
helm repo update
```

---

### Uninstall Spatial Services

You can uninstall all services if you want to re-install

```shell
helm uninstall spatial
```


\
By default, the auto-scaling (HPA) is disabled. You can experiment
auto-scaling by enabling HPA settings in
`gitlab-deployment-values.yaml`. You can also make more customization to
the deployment. Updating the manifest file
`gitlab-deployment-values.yaml` from your disk of Cloud Shell, click
\'{}\' to open the editor.


\
If you are using the OGC services please refer to the on-premise docs ([WFS](https://docs.precisely.com/docs/sftw/spectrum/22.1/en/webhelp/Spatial/Spatial/source/Resources/resources/repoman/wfs_settings.html), [WMS](https://docs.precisely.com/docs/sftw/spectrum/22.1/en/webhelp/Spatial/Spatial/source/Resources/resources/repoman/wms_settings.html), [WMTS](https://docs.precisely.com/docs/sftw/spectrum/22.1/en/webhelp/Spatial/Spatial/source/Resources/resources/repoman/wmts_settings.html)) to configure the Online resource / Service URL with the public access url (Ingress EXTERNAL-IP).
\
\
\
NAVIGATION:

- [Getting Started - Spatial Cloud Native: Azure AKS](README.md)
- [Next Step -> Step 6: Verify Deployment](verify_deployment.md)
