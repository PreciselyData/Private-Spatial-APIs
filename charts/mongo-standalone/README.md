MongoDB Standalone Helm
=======

TL;DR;
------

```console
$ helm install mongo ./mongo-standalone
```

use default connection string to connect
```
mongodb://<host>:<port>/
```

Introduction
------------

This is a sample MongoDB container deployment using the Helm project. This is designed for testing purpose.

This will create the following in your Kubernetes cluster:

 * Create a pod named *mongo*
 * Create a service named *mongo*
 * Initialize the mongo as a single node replica set with auth off
 
Note: by default, the Mongo will use the emptyDir{} volume for data. It will be deleted permanently after the pod is deleted.
 
For more detailed information please reference to [GitHub repository](https://github.com/docker-library/mongo/tree/master/7.0).

Legal Notices
-------------

https://github.com/docker-library/mongo/blob/master/LICENSE
