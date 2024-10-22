# Feature service only deployment

If you only need search capability from Spatial API (no Mapping or Tiling needed) and only work with TAB file based datasets. The deployment described in this section may simplify the dpeloyment process for you.

The deployment includes,

* Deploy only Feature service
* Feature service is configured to use a FileSystem based repository
* FileSystem repository is configured to auto harvest TAB files in /opt/data/data folder

A PVC is still required in this deployment

## Prepare your customized values file
Make a copy of deploy/feature-only-deployment-values.yaml. Customize the settings based on your environment and needs, such as docker image registry url, ingress host etc.

> Also, for more information, refer to the comments in [values.yaml](../../../charts/private-spatial-apis/values.yaml)

## Installation of Private Spatial APIs Helm Chart
Deploy the charts will the vaules yaml file

```
helm install spatial ~/charts/private-spatial-apis -f your-values.yaml
```

Or generate Kubernetes manifest file and use kubectl to deploy

```
helm template ~/charts/private-spatial-apis -f your-values.yaml > spatial-deployment.yaml
```

```
kubectl apply -f spatial-deployment.yaml -n <your-namespace>
```

Wait till Feature service pod is up and running
```
kubectl get pod -n <your-namespace>
```

## Copy your TAB files into mount folder in Feature pod

The following cmd will copy your datasets under <local-data-folder> folder to the mount folder. You can have sub-folders to better originate your datasets. The relative path will be reflected in the harvested named tables.

```
kubectl cp <local-data-folder> <your-namespace>/<feaure-pod-name>:/opt/data/data/
```

> NOTE: if you encounter permission errors, check your PV/PVC settings [also see](https://kubernetes-csi.github.io/docs/support-fsgroup.html).

Ensure the lock file is deleted
```
kubectl -n <your-namespace> exec <feaure-pod-name> -- rm /opt/data/data/.harvested
```

Restart the pod to trigger auto-harvest
```
kubectl rollout restart deployment -n <your-namespace>
```

Try the url below in a browser to verify the tables harvested,

http://<ingress host>:<port>/rest/Spatial/FeatureService/tables.json

> NOTE: you can repeat this step at any time when you want to add new datasets. The removed datasets will NOT be cleaned from harvested tables. You need to delete evergthing under /opt/data/resources, as well as the lock file, then restart the service.



