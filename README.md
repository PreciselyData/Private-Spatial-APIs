# Cloud Native Helm Charts

## Motivation

1. **Flexibility of deployment:**
    Spatial services are delivered as separate microservices in multiple Kubernetes pods using container-based delivery. Containers are orchestrated by Kubernetes with efficient distribution of workloads across a cluster of computers.

2. **Elastic scaling and clusterings:**
    Scale according to use cases (for example environments can scale up for overnight tile caching, scale up to meet application usage during the day). Autoscaling or manual scaling via command line or K8s dashboard. Major APIs such as Mapping, Tiling and Feature services can be separately scaled to match requirements.

3. **High availability:**
    Kubernetes handles pod health checks and ensures cluster is resilient for mission critical cases, providing auto failover. K8s monitoring tools for health and availability and server resource usage.

4. **Automatic rollbacks & rollouts:**
    Deployed from container registry. Ease of deployment and upgrades. Kubernetes can progressively roll out updates and changes to your app or its configuration. If something goes wrong, Kubernetes can and will roll back the change. Optimised infrastructure costs: Scale for usage rather than maximum anticipated capacity. Pricing model will reflect usage, hence cost of ownership can be reduced to match actual demand.

5. **Portability:**
    Can be deployed on premise or to a cloud provider. Portability and flexibility in multi-cloud environments.

  
### high level steps for Customer deployment: 
 
**_1.Download Spatial API Docker images_**
You can find the docker images that you are entitled to in the data product list below. Download the docker images to your local machine or copy the cURL snippet.
Learn more  <link to documentation that provides steps to upload images to customer's own container registry>
 
**_2.Prepare your environment_**
To deploy Spatial APIs in your Kubernetes cluster, install the following client tools:
- kubectl : https://kubernetes.io/docs/tasks/tools/
- helm3 : https://kubernetes.io/docs/tasks/tools/
Install cloud platform specific tools - https://github.com/PreciselyData/cloudnative-spatial-analytics-helm/tree/master/docs/guides
Clone GitHub repository cloudnative-spatial-analytics-helm  
 
**_3.Create your Kubernetes Cluster_**
If you don't have an existing Kubernetes cluster, you can deploy one using our sample cluster installation script.
Learn how to create Cloud Platform Kubernetes cluster
 
**_4.Create a File System_**
Spatial APIs require Spatial data such as MapInfo TAB files for providing spatial capabilities. This Spatial data should be deployed using a persistent volume. The persistent volume is backed by a File System such as EFS so that the data is ready to use immediately when the volume is mounted to the pods. If you don't have an existing File System, you can create one using our samples.
Learn how to create File System
 
**_5.Prepare a MongoDB for repository_**
A MongoDB replica set is used to persist the Spatial repository content. A Spatial repository contains metadata about the Spatial data. If you have an external instance available, just collect the connection string and credentials for further use.   
Learn more on setting up a MongoDB
 
**_6.Enabling Security_**
A Keycloak service is used for authentication and authorization. If you have an external Keycloak instance that can be accessed from inside the cluster, then collect the issuer URL for further service config, otherwise, you can deploy a Keycloak service into the cluster.
Learn how to enable security
 
**_7.Deploy Spatial APIs using helm charts_**
You are all set with the prerequisites and just one step away! Next step is to deploy the Spatial APIs helm chart.
Once you run the Spatial APIs helm install/upgrade command, it might take few seconds to complete the deployment. You can check the creation of pods using the command.
