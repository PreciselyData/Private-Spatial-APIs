## Setup AWS CloudShell

Login to AWS Management Console

Ensure you are in the right Region

Open CloudShell by clicking on the icon on the tool bar

Verify and install the following utilities,

```
aws -h
```
```
eksctl -h
```
```
kubectl -h
```

### Install kubectl
```
mkdir ~/bin
```
```
curl -o ~/bin/kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
```
```
kubectl -h
```

### Insall eksctl
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C ~/bin
```

### Install helm

```
sudo yum install openssl
```
```
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
```
```
chmod 700 get_helm.sh
```
```
./get_helm.sh
```
```
cp /usr/local/bin/helm ~/bin
```
```
helm -h
```

### Clone Getting Started resources
```
git clone https://github.com/PreciselyData/SpatialAnalytics.git
```


### [Next Step](prepare-eks-cluster.md)
