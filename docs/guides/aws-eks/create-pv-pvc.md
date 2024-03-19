## Create PV and PVC

### Create a StorageClass for EFS Driver

find the template file `~/SpatialAnalytics/deploy/aws-eks/efs-sc.yaml` and update it with the file system id of your EFS file system

```
...
fileSystemId: fs-0a8838e5f81aa5cb3
...
```
```
kubectl apply -f ~/SpatialAnalytics/deploy/aws-eks/efs-sc.yaml
```
Check the results
```
kubectl get sc
```
The output should look like,
```
NAME            PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
efs-sc          efs.csi.aws.com         Delete          Immediate              false                  16s
```

### Create a PVC

We will deploy spatial services into a new namespace 'spatial', so create the namespace first,
```
kubectl create ns spatial
```

Create a PVC in the namespace that dynamically provisioning a PV using efs-sc storage class,
```
kubectl apply -f ~/SpatialAnalytics/deploy/aws-eks/pvc.yaml -n spatial
```
Check results, wait until the pvc status becomes `Bound`.
```
kubectl get pvc -n spatial
```

### [Next Step](prepare-repository-database.md)
