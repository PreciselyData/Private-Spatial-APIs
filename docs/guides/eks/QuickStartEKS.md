# Installing Spatial Analytics Helm Chart on AWS EKS

### Before starting
Make sure you have a AWS account with following permissions:  
  - create IAM roles  
  - create IAM policies  
  - create EKS clusters (EC2 based)  
  - create EFS filesystem  
  
## Step 1: Prepare your environment
To deploy Spatial Analytics application in AWS EKS, install the following client tools:

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm3](https://helm.sh/docs/intro/install/)

##### Amazon Elastic Kubernetes Service (EKS)

- [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)


### Clone Spatial Analytics helm charts & resources
```
git clone https://github.com/PreciselyData/cloudnative-spatial-analytics-helm
```

## Step 2: Create K8s Cluster (EKS)

You can create the EKS cluster or use an existing EKS cluster.

- If you DON'T have a EKS cluster, we have provided you with a
  sample [cluster installation script](../../../cluster-sample/create-eks-cluster.yaml). Run the following command from
  parent directory to create the cluster using the script:
    ```shell
    eksctl create cluster -f ./cluster-sample/create-eks-cluster.yaml
    ```

- If you already have an EKS cluster, make sure you have following addons or plugins related to it, installed on the
  cluster:
    ```yaml
    addons:
    - name: vpc-cni
    - name: coredns
    - name: kube-proxy
    - name: aws-efs-csi-driver
    ```
  Run the following command to install addons only:
    ```shell
    aws eks --region [aws-region] update-kubeconfig --name [cluster-name]
    
    eksctl create addon -f ./cluster-sample/create-eks-cluster.yaml
    ```
- Once you create EKS cluster, you can
  apply [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) so that the
  cluster can be scaled vertically as per requirements. We have provided a sample cluster autoscaler script. Please run
  the following command to create cluster autoscaler:
    ```shell
    kubectl apply -f ./cluster-sample/cluster-auto-scaler.yaml
    ```
- To enable [HorizontalPodAutoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/), the
  cluster also needs a [Metrics API Server](https://github.com/kubernetes-sigs/metrics-server) for capturing cluster
  metrics. Run the following command for installing Metrics API Server:
    ```shell
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    ```
- The spatial-analytics service requires ingress controller setup. Run the following command for setting up NGINX ingress controller:
  ```shell
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm install nginx-ingress ingress-nginx/ingress-nginx -f ./cluster-sample/ingress-values.yaml
  ```
  *Note: You can update the nodeSelector according to your cluster's ingress node.*

  Once ingress controller setup is completed, you can verify the status and get the ingress URL by using the following command:
  ```shell
  kubectl get services -o wide -w nginx-ingress-ingress-nginx-controller    
  ```

**NOTE**: EKS cluster must have the above addons and ingress for the ease of installation of spatial-analytics Helm Chart.

## Step 3: Download Spatial Analytics Docker Images

The docker files can be downloaded from Precisely's Data Portfolio. For information about Precisely's Data Portfolio,
see the [Precisely Data Guide](https://dataguide.precisely.com/) where you can also sign up for a free account and
access software, reference data and docker files available in [Precisely Data Experience](https://data.precisely.com/).

The Spatial Analytics docker images need to be present in the ECR. If you haven't pushed the required docker
images to ECR, then you can use a sample script [upload_ecr.py](../../../scripts/images-to-ecr-uploader) to download the docker images
from [Precisely Data Experience](https://data.precisely.com/)
and push it to your Elastic Container Registry.

>Note: This script requires python, docker and AWS CLI to be installed in your system. Also make sure that AWS CLI is configured before you run the script. Run this command - ``aws sts get-caller-identity``

```shell
cd ./scripts/images-to-ecr-uploader
pip install -r requirements.txt
python upload_ecr.py --pdx-api-key [pdx-api-key] --pdx-api-secret [pdx-secret] --aws-access-key [aws-access-key] --aws-secret [aws-secret] --aws-region [aws-region]
```

There are six docker images which will be pushed to ECR with the tag of helm chart version.
1. feature-service
2. mapping-service
3. tiling-service
4. namedresource-service
5. spatialmanager-service
6. samples-data

For more details related to docker images download script, follow the instructions [here](../../../scripts/images-to-ecr-uploader/README.md)

## Step 4: Create a Persistent Volume
The Spatial Analytics Application supports caching of map tiles, file based spatial data and can be extended by
adding custom data access providers and symbology. This spatial data should be deployed using a [persistent volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).
The persistent volume is backed by Amazon Elastic File System (EFS) so that the data is ready to use immediately when the
volume is mounted to the pods.

If you don't have an existing File System, you can create one using given sample. We have provided a python script
to create EFS and link it to EKS cluster, or directly link existing EFS to the EKS cluster by creating mount targets.

**NOTE: If you already have created mount targets for the EFS to EKS cluster, skip this step.**

- If you DON'T have existing EFS, run the following commands:
  ```shell
  cd ./scripts/efs-creator
  pip install -r requirements.txt
  python ./create_efs.py --cluster-name [eks-cluster-name] --aws-access-key [aws-access-key] --aws-secret [aws-secret] --aws-region [aws-region] --efs-name [precisely-spatial-analytics-efs] --security-group-name [precisely-spatial-analytics-sg]
  ```

- If you already have EFS, but you want to create mount targets so that EFS can be accessed from the EKS cluster, run the following command:
  ```shell
  cd ../scripts/efs-creator
  pip install -r requirements.txt
  python ./create_efs.py --cluster-name [eks-cluster-name] --existing true --aws-access-key [aws-access-key] --aws-secret [aws-secret-key] --aws-region [aws-region] --file-system-id [file-system-id]
  ```
Make a note of `FileSystemId` displayed on you screen.  

#### Create a StorageClass for EFS Driver  
Update template [efs-sc.yaml](../../../deploy/eks/efs-sc.yaml) with the file system id of your EFS file system & run:  

```kubectl apply -f ./deploy/eks/efs-sc.yaml ```  

You can check the result by executing:    
```kubectl get sc```  

#### Create a PVC  
We will deploy Spatial Analytics into a new namespace 'spatial-analytics', so create a namespace first,  
```kubectl create ns spatial-analytics```

Create a PVC in the namespace that dynamically provisioning a PV using efs-sc storage class,  
```kubectl apply -f ./deploy/eks/efs-pvc.yaml -n spatial-analytics```  
Check results, wait until the pvc status becomes Bound.  
```kubectl get pvc -n spatial-analytics```

## Step 5: Prepare a database for repository
A MongoDB replica set is used to persistent repository content.

For a production deployment, a multi-node MongoDB replica set is recommended. Here is the link to [Install MongoDB](https://www.mongodb.com/docs/manual/installation/).


If you have a MongoDB replica set that can be accessed from inside the Kubernetes cluster, then collect the connection uri for further service config.

If you don't have a MongoDB replica set currently, for your convenience, you can deploy a single node MongoDB replica set for testing as below, otherwise, go to the next step.

### Install a MongoDB instance by helm for testing

Install MongoDB from helm chart
```
helm install mongo ./charts/mongo-standalone -n mongo --create-namespace
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

Create a secret for pulling image from ECR repository  
```
kubectl create secret docker-registry regcred --docker-server=[account_id].dkr.ecr.[aws_region].amazonaws.com   --docker-username=AWS   --docker-password=$(aws ecr get-login-password --region [aws-reqion]) --namespace=spatial-analytics
```
To install/upgrade the Spatial Analytics helm chart, use the following command:

```shell
helm upgrade --install spatial-analytics  --version 1.1.0 \
 ./charts/spatial-cloud-native  --dependency-update  \
 --set "global.ingress.host=[ingress-host-name]" \
 --set "repository.mongodb.url=[mongodb-url]" \ 
 --set "global.registry.url=[aws-account-id].dkr.ecr.[aws-region].amazonaws.com" \
 --set "global.registry.tag=1.1.0" \ 
 --set "global.registry.secrets=regcred" \ 
 -f ./deploy/gitlab-deployment-values.yaml \
 --namespace spatial-analytics   
```

This should install Spatial Analytics APIs and set up a sample dataset that can be used to play around with the product.

> Also, for more information, refer to the comments in [values.yaml](../../../charts/spatial-cloud-native/values.yaml)
#### Mandatory Parameters
* ``global.ingress.host``: The Host name of Ingress e.g. http://aab329b2d767544.us-east-1.elb.amazonaws.com
* ``repository.mongodb.url``: The Mongo DB connection URI e.g. mongodb+srv://<username>:<password>@mongo-svc.mongo.svc.cluster.local/spatial-repository?authSource=admin&ssl=false 
* ``global.registry.url``: The ECR repository for Spatial Analytics docker image e.g. account_id.dkr.ecr.us-east-1.amazonaws.com
* ``global.registry.tag``: The docker image tag value e.g. 1.1.0 or latest.
* ``global.registry.secrets``: The name of the secret holding ECR credential information.

For more information on helm values, follow [this link](../../../charts/spatial-cloud-native/README.md#helm-values).

After all the pods in namespace 'spatial-analytics' are in 'ready' status, launch SpatialServerManager in a browser with the URL below (You may need to accept the default self-signed certificate from Ingress. Check out the ingress document on how to change the certificate if you need). By default, the security is off, so you can login with any username/password. You should be able to browser named resources and pre-view maps. The link to Spatial Manager: `https://<your external ip>/SpatialServerManager`

## Step 7: Monitoring Spatial Analytics Helm Chart Installation

Once you run Spatial Analytics helm install/upgrade command, it might take a couple of seconds to trigger the deployment. You can run the following command to check the creation of pods. Please wait until all the pods are in running state:
```shell
kubectl get pods -w --namespace spatial-analytics 
```

When all the pods are up, you can run the following command to check the ingress service host:
```shell
kubectl get services --namespace spatial-analytics 
```

## Next Sections
- [Spatial Analytics API Usage](../../../charts/geo-addressing/README.md#geo-addressing-service-api-usage)
- [Metrics, Traces and Dashboard](../../MetricsAndTraces.md)
- [FAQs](../../faq/FAQs.md)


[🔗 Return to `Table of Contents` 🔗](../../../README.md#guides)
