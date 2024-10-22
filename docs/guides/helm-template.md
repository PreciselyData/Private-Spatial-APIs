# Helm template

In case Helm chart deployment is not possible, you can use Helm to generate Kubernetes manifest file from the charts that allows you to deploy services using kubectl cmd directly. The manifest file also gives you more insights on how the service is to be deployed.

## Prepare your customized values file
Make a copy of one of supplied sample values yaml files as a start point, for example gitlab-deployment-values.yaml, customize the settings based on your environment and needs, such as docker image registry url, services, CPU/Mem etc.

> Also, for more information, refer to the comments in [values.yaml](../../charts/private-spatial-apis/values.yaml)

## Generate Kubernetes manifest file from charts

The following helm cmd will generate Kubernetes manifest file and output to file spatial-deployment.yaml
```
helm template ~/charts/private-spatial-apis -f your-cusmtized-values.yaml > spatial-deployment.yaml
```

More details on [Helm Template](https://helm.sh/docs/helm/helm_template/)

## Deploy from Kubernetes manifest file

The following cmd will deploy spatial api into your Kubernetes cluster
```
kubectl apply -f spatial-deployment.yaml -n <your-namespace>
```