## Deploy spatial services using helm charts

### Setup helm repository

You should have a credentials from Precisely for the helm registry,
```
helm repo add spatial https://gitlab.com/api/v4/projects/24255413/packages/helm/stable --username <username> --password <password>
```
```
helm repo update
```
```
helm search repo spatial
```

Create a secret for image pull (using the same credentials)
```
kubectl -n spatial create secret docker-registry regcred-gitlab --docker-server=registry.gitlab.com --docker-username=<username> --docker-password=<password>
```


### Deploy Spatial Services

There are two deployment files to choose from that require different amount of resources (CPU and Memory). Start from the small one (`~/SpatialAnalytics/deploy/gitlab-deployment-small-values.yaml`). A production deployment should use `~/SpatialAnalytics/deploy/gitlab-deployment-values.yaml`. If you use your external Postgres Database, update the information in the manifest file `~/SpatialAnalytics/deploy/values-jackrabbit-postgres.yaml`. The value of the `global.ingress.host` is the Ingress External IP.
```
helm install spatial spatial/spatial-cloud-native --version 1.0.0 -n spatial -f ~/SpatialAnalytics/deploy/gitlab-deployment-small-values.yaml -f ~/SpatialAnalytics/deploy/values-jackrabbit-postgres.yaml --set global.ingress.host=<your external ip>
```

After all the pods in namespace 'spatial' are in 'ready' status, launch SpatialServerManager in a browser with the URL below (You may need to accept the default self-signed certificate from Ingress. Check out the ingress document on how to change the certificate if you need). By default, the security is off, so you can login with any username/password. You should be able to browser named resources and pre-view maps.
`https://<your external ip>/SpatialServerManager`
   
If you are using the OGC services please refer to the on-premise docs ([WFS](https://docs.precisely.com/docs/sftw/spectrum/22.1/en/webhelp/Spatial/Spatial/source/Resources/resources/repoman/wfs_settings.html), [WMS](https://docs.precisely.com/docs/sftw/spectrum/22.1/en/webhelp/Spatial/Spatial/source/Resources/resources/repoman/wms_settings.html), [WMTS](https://docs.precisely.com/docs/sftw/spectrum/22.1/en/webhelp/Spatial/Spatial/source/Resources/resources/repoman/wmts_settings.html)) to configure the Online resource / Service URL with the public access url (Ingress EXTERNAL-IP).


### [Next Step](enable-security.md)
