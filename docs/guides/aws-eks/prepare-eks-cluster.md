## Prepare EKS cluster
Also see AWS Document https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html

Note: an EC2 based EKS cluster is used in this doc. Fargate based EKS may be used as well but it has extra steps required that are not covered here.

### Create an Amazon EKS cluster

Choose kubernetes version (1.21-1.22). Pick up a name and region for your cluster, then create the cluster with cli below (e.g. `spatial-cloud-native`, `us-east-2`). Optionally, you can specify a node type, defaut is `m5.large`.
```
eksctl create cluster --version 1.21 --instance-types t3.xlarge --name <cluster name> --region <your region>
```
Wait for the output like below. This process may take more than ten minutes to finish.
```
...
2022-07-15 21:46:39 [✔]  EKS cluster "spatial-cloud-native" in "us-east-2" region is ready
```
Once finished, kubectl should be configured for the cluster
```
kubectl get nodes
```
```
NAME                                           STATUS   ROLES    AGE     VERSION
ip-192-168-12-154.us-east-2.compute.internal   Ready    <none>   2m32s   v1.21.12-eks-5308cf7
ip-192-168-50-23.us-east-2.compute.internal    Ready    <none>   2m35s   v1.21.12-eks-5308cf7
```

### Install Ingress Controller (nginx)
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/aws/deploy.yaml
```
Find the external host name
```
kubectl get svc -n ingress-nginx
```

Looking for the EXTERNAL-IP for output from above. 
```
NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP                                                                     PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.100.251.130   af5fd6acf60f747e492756edb9726215-e6f65bc2cad48f49.elb.us-east-2.amazonaws.com   80:30360/TCP,443:32694/TCP   4h42m
ingress-nginx-controller-admission   ClusterIP      10.100.32.220    <none>                                                                          443/TCP                      4h42m
```
The public access url would be like below. Try the url from your browser, you should see a 404 page from 'nginx'.
```
https://af5fd6acf60f747e492756edb9726215-e6f65bc2cad48f49.elb.us-east-2.amazonaws.com/
```


### Install Amazon EFS CSI Driver

also see https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html

```
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.3"
```
You should see few efs-csi-* pods up and running.
```
kubectl get pod -n kube-system
```


### Create the policy for the CSI Driver and attach it to the node group role.

Download the IAM policy document from GitHub. You can also view the [policy document](https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/docs/iam-policy-example.json).
```
curl -o iam-policy-example.json https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/docs/iam-policy-example.json
```
Create the policy. You can change `Spatial_EKS_EFS_CSI_Driver_Policy` to a different name, but if you do, make sure to change it in later steps too.
```
aws iam create-policy --policy-name Spatial_EKS_EFS_CSI_Driver_Policy --policy-document file://iam-policy-example.json
```

Attach this policy to the role of node group (auto created). First, find the IAM role of the node group in Management Console

Go to `EKS cluster` > `Compute` > `Node Groups` > click on the group name > `Details` > `Node IAM role ARN` > click on the role name > `Add permissions` > `Attach policies`,
Then select the policy `Spatial_EKS_EFS_CSI_Driver_Policy` to add.


At this point, the EKS cluster is ready for use. After the try, you can delete the cluster with the cli below
```
eksctl delete cluster --name <cluster name> --region <your region>
```

### Allow NFS traffic into EKS cluster

Check the security groups used by the EKS cluster if the NFS traffic is allowed for inbound. 

Go to the EKS cluster you created > `Networking` > `Cluster security groups`, click the group id > `Inbound rules` > `Edit inbound rules` > `Add rule`, select `Type` as `NFS`, `Source` as `Anywhere-IPv4`, like shown below. Add allow NFS traffic rule. You can have more restrict rule but ensure that all EKS nodes should allow to access. Do the same to the security group under `Networking` > `Additional security groups`.
```
IP version	Type	Protocol	Port range	Source
IPv4		NFS	TCP		2049		0.0.0.0/0
```
Note: If the cluster (nodes) can't access the EFS file system, spatial service pods will not be able to mount the volume and will stuck on pod creation status. Describe the pod to find out more detailed information.


### [Next Step](setup-efs-file-shares.md)
