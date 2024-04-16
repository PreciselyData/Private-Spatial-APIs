# Spatial Analytics Helm Charts

## Motivation

1. **Flexibility of deployment**

   Spatial services are delivered as separate microservices in multiple Kubernetes pods using container-based delivery.
   Containers are orchestrated by Kubernetes with efficient distribution of workloads across a cluster of computers.

2. **Elastic scaling and clusterings**

   Scale according to use cases (for example environments can scale up for overnight tile caching, scale up to meet
   application usage during the day). Autoscaling or manual scaling via command line or K8s dashboard. Major APIs
   such as Mapping, Tiling and Feature services can be separately scaled to match requirements.

3. **High availability**

   Kubernetes handles pod health checks and ensures cluster is resilient for mission critical cases, providing
   auto failover. K8s monitoring tools for health and availability and server resource usage.

4. **Automatic rollbacks & rollouts**

   Deployed from container registry. Ease of deployment and upgrades. Kubernetes can progressively roll out updates
   and changes to your app or its configuration. If something goes wrong, Kubernetes can and will roll back the change.
   Optimised infrastructure costs: Scale for usage rather than maximum anticipated capacity. Pricing model will reflect usage,
   hence cost of ownership can be reduced to match actual demand.

5. **Portability**

   Can be deployed on premise or to a cloud provider. Portability and flexibility in multi-cloud environments.

> This solution is specifically for users who are looking for a REST Spatial Analytics API and Kubernetes based deployments.

> [!IMPORTANT]  
> Please consider these helm charts as recommendations only. They come with predefined configurations that may not be the best fit for your needs. Configurations can be tweaked based on the use case and requirements.

## Architecture
TODO
![architecture.png](images/spatial_analytics_architecture.png)


### Components

- [Docker Images](scripts/images-to-ecr-uploader/README.md#description)
- [Helm Charts](charts/README.md)

## Guides

- [Quickstart Guide EKS](./docs/guides/eks/QuickStartEKS.md)
- [Upgrade Guide EKS](./docs/guides/eks/UninstallGuide.md)
- [Uninstall Guide EKS](./docs/guides/eks/UpgradeGuide.md)
- [Quickstart Guide GKE](./docs/guides/gke/QuickStartGKE.md)
- [Uninstall Guide GKE](./docs/guides/gke/UpgradeGuide.md)
- [Upgrade Guide GKE](./docs/guides/gke/UninstallGuide.md)
- [Quickstart Guide AKS](./docs/guides/aks/QuickStartAKS.md)
- [Uninstall Guide AKS](./docs/guides/gke/UpgradeGuide.md)
- [Upgrade Guide AKS](./docs/guides/aks/UninstallGuide.md)

## Installing Spatial Analytics Helm Chart
### 1. Prepare your environment
Install Client tools required for installation. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-1-prepare-your-environment) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-1-setup-cloud-shell) | [AKS](./docs/guides/gke/QuickStartAKS.md#step-1-prepare-your-environment)

### 2. Create K8s cluster
Create or use an existing K8s cluster. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-2-create-k8s-cluster-eks) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-2-create-k8s-cluster-gke) | [AKS](./docs/guides/gke/QuickStartAKS.md#step-2-create-k8s-cluster-aks)

### 3. Download Spatial Analytics Images
Download docker images and upload to own container registry. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-3-download-spatial-analytics-docker-images) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-3-download-spatial-analytics-docker-images) | [AKS](./docs/guides/gke/QuickStartAKS.md#step-3-download-spatial-analytics-docker-images)

### 4. Create a Persistent Volume
Create a  persistent volume for storing file based spatial data/various caches. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-4-create-a-persistent-volume) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-4-create-a-persistent-volume-and-persistent-volume-claim) | [AKS](./docs/guides/gke/QuickStartAKS.md#step-4-create-a-persistent-volume)

### 5. Prepare a database for repository
Install a MongoDB databse or use an existing instance. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-5-prepare-a-database-for-repository) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-5-prepare-a-database-for-repository) | [AKS](./docs/guides/gke/QuickStartAKS.md#step-5-prepare-a-database-for-repository)

### 6. Install Spatial Analytics Helm Chart
Deploy Spatial Analytics helm chart to K8s cluster. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-6-installation-of-spatial-analytics-helm-chart) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-6-installation-of-spatial-analytics-helm-chart) | [AKS](./docs/guides/gke/QuickStartAKS.md#step-6-installation-of-spatial-analytics-helm-chart)

### 7. Enable Security (optional)
Install or use an existing Keycloak instance. Click on the link to get steps for specific cloud platform:
[EKS](./docs/guides/eks/QuickStartEKS.md#step-7-enabling-security---authnauthz-optional) | [GKE](./docs/guides/gke/QuickStartGKE.md#step-7-enabling-security---authnauthz-optional) | [AKS](./docs/guides/gke/QuickStartAKS.md#step-7-enabling-security---authnauthz-optional)

### 8. Use Spatial Utilities
There are various utilities for:
- Generating MapTiling requests
- Generating Map tiles for the WMTS service
- Uploading maps from MapInfo Pro to the Spatial repository
- Importing and exporting Spatial repository.

More details on Spatial Utilities can be found [here](./docs/guides/spatial-utilities.md).

## Spatial Analytics Helm Version Chart

Following is the helm version chart against Spatial Analytics PDX docker image version.

| Docker Image PDX Version     | Helm Chart Version |
|------------------------------|--------------------|
| `1.0.0/2024.0/April 30,2024` | `0.1.1`️ |


> NOTE: The docker images pushed to the image repository should be tagged with the current helm chart version.
> Refer [Downloading Spatial Analytics Docker Images](docs/guides/eks/QuickStartEKS.md#step-3-download-docker-images) for more information.

## Miscellaneous

- [Metrics](docs/MetricsAndTraces.md#generating-insights-from-metrics)
- [Application Tracing](docs/MetricsAndTraces.md#generating-insights-from-metrics)
- [Logs and Monitoring](docs/MetricsAndTraces.md#generating-insights-from-metrics)
- [FAQs](docs/faq/FAQs.md)

## References

- [Releases](https://github.com/PreciselyData/cloudnative-spatial-analytics-helm/releases)
- [Helm Values](charts/spatial-cloud-native/README.md#helm-values)
- [Environment Variables](charts/spatial-cloud-native/README.md#environment-variables)
- [Memory Recommendations](charts/spatial-cloud-native/README.md#memory-recommendations)

## Links

- [Spatial Analytics API Guide](.)
- [Helm Chart Tricks](https://helm.sh/docs/howto/charts_tips_and_tricks/)
- [Nginx Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/)