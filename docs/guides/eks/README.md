<p align="center">
  <img src="../../../Precisely_Logo.png" alt="precisely-logo"/>
</p>

<h1 align="center">Getting Started - Spatial Cloud Native: AWS EKS</h1>


### Before starting

Make sure you have the following items before starting:

    AWS account with following permissions.
        create IAM roles
        create IAM policies
        create EKS clusters (EC2 based)
        create EFS filesystem
        use CloudShell

To make it easier, this guide is based on AWS CloudShell.

### Let's start

# Installing cloudnative-spatial Helm Chart on AWS EKS

## Step 1: Download Spatial API Docker images

You can find the docker images that you are entitled to in the data product list below. Download the docker images to your local machine or copy the cURL snippet.
Learn more  <link to documentation that provides steps to upload images to customer's own container registry>


## Step 2: Prepare your environment

To deploy the Geo-Addressing application in AWS EKS, install the following client tools:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm3](https://helm.sh/docs/intro/install/)
- [Install cloud platform specific tools](https://github.com/PreciselyData/cloudnative-spatial-analytics-helm/tree/master/docs/guides)
- [Clone GitHub repository](https://github.com/PreciselyData/cloudnative-spatial-analytics-helm)

## Step 3: Create the EKS Cluster

If you don't have an existing Kubernetes cluster, you can deploy one using our sample cluster installation script.
Learn how to create [Cloud Platform Kubernetes cluster](../eks/prepare-eks-cluster.md)

## Step 4: Create a File System

Spatial APIs require Spatial data such as MapInfo TAB files for providing spatial capabilities. This Spatial data should be deployed using a persistent volume. The persistent volume is backed by a File System such as EFS so that the data is ready to use immediately when the volume is mounted to the pods. If you don't have an existing File System, you can create one using our samples.
[Learn how to create File System](../eks/setup-efs-file-shares.md)

## Step 5: Prepare database for repository

A Database (PostgreSQL or MSSQL Server) instance is used to persistent repository content. If you have an external instance available, just collect the connection string and credentials for further use. You can also follow the steps below to install a postgres database to the EKS cluster.    
[Learn more on setting up a database](../eks/prepare-repository-database.md)

## Step 6: Enabling Security

A Keycloak service is used for authentication and authorization. If you have an external Keycloak instance that can be accessed from inside the cluster, then collect the issuer URL for further service config, otherwise, you can deploy a Keycloak service into the cluster.
[Learn how to enable security](../eks/enable-security.md)

## Step 7: Deploy Spatial APIs using helm charts

You are all set with the prerequisites and just one step away! Next step is to deploy the Spatial APIs helm chart.
Once you run the Spatial APIs helm install/upgrade command, it might take few seconds to complete the deployment. You can check the creation of pods using the [command](.).
[Learn how to Install Spatial APIs using helm charts](../eks/deploy-spatial-services.md)

## Step 8: Spatial Utilities

Take advantage of the productivity tools that Spectrum Spatial has for working with spatial data. 
Productivity tools are provided for generating MapTiling requests, generating map tiles for the WMTS service, uploading maps from MapInfo Pro to the Spatial repository, and importing and exporting the spatial repository.
[Learn more about Spatial Utilities](../spatial-utilities.md)

## Next Sections
- [Geo Addressing API Usage](.)
- [Metrics, Traces and Dashboard](.)
- [FAQs](../../faq/FAQs.md)


[🔗 Return to `Table of Contents` 🔗](../../../README.md#guides)


