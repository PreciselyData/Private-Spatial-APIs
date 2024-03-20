<p align="center">
  <img src="../../../Precisely_Logo.png" alt="precisely-logo"/>
</p>

<h1 align="center">Getting Started - Spatial Cloud Native: Azure AKS</h1>

### **Before starting**

Make sure you have the following items before starting:

-   Access tokens to Helm registry and Docker image registry (they could
    be the same or separated ones).

It is recommended to use a single Azure subscription to complete this
tutorial. To make it easier, this tutorial is based on Azure portal and
Azure Cloud Shell (Bash). There's nothing you need to pre-install on
your PC except pgAdmin4 and WebDAV client. In order to achieve the best
performance, try to create all resources in the same region. Some of the
tasks in the document are simplified for easy starting, so it's not
recommended for any serious deployment.

### **Let\'s** start

### [Step 1: Create a database](create_a_database.md)

### [Step 2: Prepare AKS cluster](prepare_aks_cluster.md) 

### [Step 3: Setup Azure File shares](setup_azure_file_shares.md)

### [Step 4: Create PersistentVolume (PV) and PersistentVolumeClaim (PVC)](create_pv_pvc.md)

### [Step 5: Prepare and deploy using helm charts](prepare_and_deploy_using_helm_charts.md)

### [Step 6: Verify Deployment](verify_deployment.md)

### [Step 7: Enabling security AKS AuthN/AuthZ](Enabling_security_AKS___AuthN_AuthZ.md)

### [Step 8: Spatial Utilities](../spatial-utilities.md)
