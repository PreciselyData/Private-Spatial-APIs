## Setup EFS File shares

An EFS file system is used to share data (such as MapInfo TAB files) across all services on different nodes in the cluster. The further PV and PVC definition will reference to this file share by access points. Please ensure the EFS is in the same VPC as the cluster you will use from.

Also see https://docs.aws.amazon.com/efs/latest/ug/creating-using-create-fs.html

### Create EFS file system

Go to `EFS` (https://`<your region>`.console.aws.amazon.com/efs/home) > `File systems`, making ensure it's in the same region with the EKS cluster, then create an EFS file system `Create file system` > give a name and select the EKS cluster VPC (auto-created, you can tell by the name, or you can find it in the cluster page). Write down the `file-system-Id` after finished for further use (e.g. `fs-0a8838e5f81aa5cb3`).

### Allow NFS traffic into EFS

Check the security group of the EFS if the NFS traffic is allowed for inbound. 

Go to the EFS you created > `Network` > `Security groups`, write down the group id (it may take some time to show up).

Go to `EC2` (https://`<your region>`.console.aws.amazon.com/ec2) > `Network & Security` > `Security Groups`, find the group you written down above > `Inbound rules` > `Edit inbound rules` > `Add rule`, select `Type` as `NFS`, `Source` as `Anywhere-IPv4`, like shown below. You can have more restrict rule but ensure all EKS nodes should allow to access.
```
IP version	Type	Protocol	Port range	Source
IPv4		NFS	TCP		2049		0.0.0.0/0
```

### [Next Step](prepare-repository-database.md)
