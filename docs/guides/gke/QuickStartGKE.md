# Installing Private Spatial APIs Helm Chart on Google Cloud GKE

### Before starting
Make sure you have a Google Cloud account with following permissions:  
- A project that IAM has roles of Kubernetes Engine Admin (roles/container.admin or roles/owner) and Artifact Registry Writer (roles/artifactregistry.writer)
- Cloud Shell
  
## Step 1: Setup Cloud Shell
Login to Google Cloud Console

Ensure you are in the right project

Open Cloud Shell by clicking on the icon on the tool bar

Verify the following utilities,

```
gcloud -h
```
```
kubectl -h
```
```
helm -h
```

### Clone Private Spatial APIs helm charts & resources
```
git clone https://github.com/PreciselyData/Private-Spatial-APIs
```

## Step 2: Create K8s Cluster (GKE)

Also see Google Cloud Document https://cloud.google.com/kubernetes-engine?hl=en

> NOTE: a GKE Autopilot cluster is used in this doc. A Standard mode cluster can also be used but it has extra steps required that are not covered here.

### Create GKE cluster

Set up the project and region to use, e.g. my-project, us-east1
```
gcloud config set compute/region us-east1
```
The project should be set automatically, but you can update it if needed,
```
gcloud config set project <my-project>
```
Check the settings,
```
gcloud config list
```

Create GKE cluster (autopilot) named spatial-cloud-native. You can specify different project and region with `--project` and `--region`.
```
gcloud container clusters create-auto spatial-cloud-native --region us-east1 --cluster-version 1.29.1
```
It may take few minutes to create the cluster. Wait until the command finished.
```
kubectl get nodes
```
You may see no resources at beginning as no pods deployed yet.
```
No resources found
```
> NOTE: if the cluster version was not found, using the following command to list all valid cluster versions. Looking for one under REGULAR channel.
```
gcloud container get-server-config
```

### Install Ingress Controller (ingress-nginx)
First, add cluster admin permission:
```
kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)
```
Then, install ingress controller:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/cloud/deploy.yaml
```
Find the external IP
```
kubectl get svc -n ingress-nginx
```
Looking for the EXTERNAL-IP from output. Wait a moment and try again if the EXTERNAL-IP is not assigned.
```
NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   34.118.225.23    34.23.192.143   80:31548/TCP,443:32362/TCP   21m
ingress-nginx-controller-admission   ClusterIP      34.118.232.254   <none>          443/TCP                      21m                                                                        443/TCP                      4h42m
```
The public access url would be like below. Try the url from your browser, you should see a 404 page from 'nginx'.
```
https://34.23.192.143
```

## Step 3: Download Private Spatial APIs Docker Images

The docker files can be downloaded from Precisely's DI Suite Console.

AWS Artifact Repository is used to hold the docker images and deploy from it.

### Create Artifact registry

Run the command with your region,
```
gcloud artifacts repositories create spatial-repo \
    --repository-format=docker \
    --location=<your region> \
    --description="Docker repository"
```

Find out 'Registry URL',
```
gcloud artifacts repositories describe spatial-repo --location=<your region>
```

### Load images to artifact registry

Due to the disk space limitation on cloudshell, you need to unzip the image file you downloaded from DIS (spatial-cloud-native-images.zip) on your local machine and upload the six tar files to cloudshell. In cloudshell, click on the Upload menu to upload the image tar files.

Run the shell scripts to load images to artifact registry,
```
chmod a+x ~/Private-Spatial-APIs/scripts/gke/push-images.sh
```
```
~/Private-Spatial-APIs/scripts/gke/push-images.sh <your registry url>
```

you can also load images one by one if there's no enough disk space available (restart the cloudshell may release more disk space).
```
~/Private-Spatial-APIs/scripts/gke/push-images.sh <your registry url> <tar file name without ext>
```

List images in the artifact registry
```
gcloud artifacts docker images list <your registry url>
```

Once you finished the testing, if you do not want this artifact registry anymore, you can delete it for cost saving,
```
gcloud artifacts repositories delete spatial-repo --location=<your region>
```

## Step 4: Create a Persistent Volume and Persistent Volume Claim

A PV (Persistent Volume) is required to share files across all services (pods), including
- File based Spatial data sets, such as Mapinfo TAB, Shape, GeoPackage and Geodatabase etc.
- Tile cache
- Map image cache
- Custom Symbols
- Extended DataProviders
- JDBC drivers
	
### Create a PVC/PV

We will use `standard-rwx` auto provisioner to provision a PV through a PVC. There are other provisioners that may give better overall performance.

Create a PVC that dynamically provisioning a PV using standard-rwx storage class,
```
kubectl apply -f ~/Private-Spatial-APIs/deploy/gke/pvc.yaml
```
Check results, the pvc status will become `Bound` after service pods are deployed.
```
kubectl get pvc
```

## Step 5: Prepare a database for repository
A MongoDB replica set is used to persistent repository content.

For a production deployment, a multi-node MongoDB replica set is recommended. Here is the link to [Install MongoDB](https://www.mongodb.com/docs/manual/installation/).


If you have a MongoDB replica set that can be accessed from inside the Kubernetes cluster, then collect the connection uri for further service config.

If you don't have a MongoDB replica set currently, for your convenience, you can deploy a single node MongoDB replica set for testing as below, otherwise, go to the next step.

### Install a MongoDB instance by helm for testing

Install MongoDB from helm chart
```
helm install mongo ~/Private-Spatial-APIs/charts/mongo-standalone -n mongo --create-namespace
```
```
kubectl get pod -n mongo
```
Wait until the mongo pod is ready
```
NAME                                      READY   STATUS    RESTARTS   AGE
mongo-XXXXXXXXXX-XXXX                     1/1     Running   0          8m35s
```
This will install a single node replica set instance without authentication
```
connection uri = mongodb://mongo-svc.mongo.svc.cluster.local/spatial-repository?authSource=admin&ssl=false
```

## Step 6: Installation of Spatial Analytics Helm Chart

> NOTE: For every helm chart version update, make sure you run the [Step 3](#step-3-download-geo-addressing-docker-images) for uploading the docker images with the newest tag.

### Deploy Spatial Services

There are two deployment files to choose from that require different amount of resources (CPU and Memory). Start from the small one (`~/Private-Spatial-APIs/deploy/gitlab-deployment-small-values.yaml`). A production deployment should use `~/Private-Spatial-APIs/deploy/gitlab-deployment-values.yaml`.

> NOTE: if you are not using MongoDB deployed from this guide, you need to update the mongo uri in the values file before install.

```
helm install spatial ~/Private-Spatial-APIs/charts/spatial-cloud-native \
     -f ~/Private-Spatial-APIs/deploy/gitlab-deployment-small-values.yaml \
     --set global.registry.secrets=null \
     --set global.registry.url=<your registry url>
```
Wait until all services are ready. It may take 5 to 8 minutes to get ready for the first time. 
```
kubectl get pod
```

You can also deploy services with hpa enabled, here is an example (check [gitlab-deployment-values.yaml](../../../deploy/gitlab-deployment-values.yaml) for more details),
```
helm install spatial ~/Private-Spatial-APIs/charts/spatial-cloud-native \
     -f ~/Private-Spatial-APIs/deploy/gitlab-deployment-values.yaml \
     --set global.registry.secrets=null \
     --set global.registry.url=<your registry url> \
     --set mapping-service.hpaEnabled=true \
     --set mapping-service.maxReplicaCount=3
```

After all the pods are in 'ready' status, launch SpatialServerManager in a browser with the URL below (You may need to accept the default self-signed certificate from Ingress. Check out the ingress document on how to change the certificate if you need). By default, the security is off, so you can login with any username/password. You should be able to browser named resources and pre-view maps.
`https://<your external ip>/SpatialServerManager`

In SpatialServerManager, go to `Samples` -> `NamedMaps` -> `DCWashMap` -> `Preview` to see the map

In a browser, get a map from mapping servie
```
https://<your external ip>/rest/Spatial/MappingService/maps/Samples/NamedMaps/DCWashMap/image.png;w=640;h=480;c=-77.0%2C38.9%2Cepsg%3A4326;z=5%20mi;r=96
```
   
You can check HPA status while services are running
```
kubectl get hpa mapping-service
```

If you are using the OGC services please refer to the on-premise docs ([WFS](https://docs.precisely.com/docs/sftw/spectrum/24.1/en/webhelp/Spatial/Spatial/source/Resources/resources/repoman/wfs_settings.html), [WMS](https://docs.precisely.com/docs/sftw/spectrum/24.1/en/webhelp/Spatial/Spatial/source/Resources/resources/repoman/wms_settings.html), [WMTS](https://docs.precisely.com/docs/sftw/spectrum/24.1/en/webhelp/Spatial/Spatial/source/Resources/resources/repoman/wmts_settings.html)) to configure the Online resource / Service URL with the public access url (Ingress EXTERNAL-IP).


## Step 7: Enabling security - AuthN/AuthZ (Optional)
A `Keycloak` (18.0.0+) is used for authentication and authorization. 
- Authenticate a user
- Issue JWT token for an authenticated user
- Verify the JWT token used in a service request
- Resource based authorization
- Manage users(realm)/roles(client)
- Federate with other IDPs

General service flow,

<img src="../../../images/security-flow.png"  width="686" height="783">


Keycloak should have KC_HTTP_RELATIVE_PATH and KC_HOSTNAME_PATH set to ‘/auth’. SCN is compatible with Keycloak version 18.0.0 ~ 24.0.1. For a production deployment, a multi-node Keycloak cluster is recommended. Here is a link to [Keycloak Install](https://www.keycloak.org/operator/installation), [Keycloak User Guides](https://www.keycloak.org/guides)

If you have a Keycloak instance that can be accessed from inside the Kubernetes cluster, then collect the issuer url for further service config. 

If you don't have a Keycloak instance available currently, for your convenience, you can deploy a Keycloak for testing by following the first step below, otherwise, you can skip the step.


### Deploy Keycloak by helm chart for testing

Identify the external loadbalancer host to expose the Keycloak Management Console UI
```
kubectl get svc -n ingress-nginx
```
looking for the EXTERNAL-IP in the output for the value of `hostname` used in the next command.

```
helm install keycloak ~/Private-Spatial-APIs/charts/keycloak-standalone -n keycloak --create-namespace --set hostname=<ingress external ip> 
```
Wait until `keycloak` pod is up and ready (`kubectl get pod -n keycloak`). It may take some time for Ingress to be deployed.
    
Open a browser and login to keycloak console with the admin credentials (default to admin/admin) at
`http://<ingress external ip>/auth`

> NOTE: this keycloak server is running in DEV mode, only use HTTP to login to admin-console.

### Create a realm for spatial services

SCN has a realm template (realm-spatial.json) that helps to setup the required realm configuration and spatial client settings. SCN authenticate with realm users and authorize with spatial client roles and resource permissions. All resource permissions (ACLs) are managed in spatial client through UMA API.

Download `~/Private-Spatial-APIs/deploy/realm-spatial.json` to your local system.
In the administration console, click on realm pulldown menu and select `Create realm`

Click on `Browse...` button, select the realm file `realm-spatial.json`, give a name to the new realm (use all lowercase name, e.g. `development`) and click the `Create` (do not double clicks).

After imported the realm from the template, use Keycloak Admin console to change admin credentials, default user credentials and spatial client secret. 

Keycloak Admin console is used to manage users in realm and roles in spatial client. SCN do not use realm roles.

also see Keycloak document about the [Management Console](https://www.keycloak.org/docs/latest/server_admin/)


### Update service config to use your realm in the keycloak
```
kubectl edit cm spatial-config
```
Update the following properties with the values below,
```
...
oauth2.enabled: "true"
oauth2.issuer-uri: "http://<ingress external ip>/auth/realms/<your realm name>"
oauth2.client-id: "spatial"
oauth2.client-secret: "fd17bc1d-cefc-41a3-8c50-bb545736caa6"
spring.security.oauth2.resourceserver.jwt.issuer-uri: "<ingress external ip>/auth/realms/<your realm name>"
...
```
> NOTE: the property `oauth2.required-authority` restricts service access to the users who have at least the ’user’ client role by default. It can be configured to any spatial client roles. A value "" will disable the restriction.

Restart all services to pick up the configuration changes
```
kubectl rollout restart deployment
```
Wait for all pods are ready
```
kubectl get pod
```

Login to Spatial Manager when all services are ready. Initial password for `admin` is `Spatialadmin0`

`https://<your external ip>/SpatialServerManager`

Verify if you can preview a map in Spatial Manager.

Please follow the user guide for how to apply permissions and other security related topics.

### IDP Federation
Keycloak Federation allows you to authenticate users from your own IDP (such as LDAP) and map user roles to spatial client roles for authorization. Referring to Keycloak documents for the details.

## Step 8: Use Spatial Utilities
There are various utilities for:
- Generating MapTiling requests
- Generating Map tiles for the WMTS service
- Uploading maps from MapInfo Pro to the Spatial repository
- Importing and exporting Spatial repository.

More details on Spatial Utilities can be found [here](../../guides/spatial-utilities.md).

## Next Sections
- [Spatial Analytics API Usage](../../../charts/private-spatial-apis/README.md)
- [Metrics](../../Metrics.md#generating-insights-from-metrics)
- [FAQs](../../faq/FAQs.md)


[🔗 Return to `Table of Contents` 🔗](../../../README.md#guides)
