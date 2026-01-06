MongoDB Standalone Helm
=======

## ⚠️ SECURITY WARNING

**DO NOT use default or hardcoded credentials in production environments!**

This chart requires you to provide secure credentials during installation. Never commit credentials to version control.

TL;DR;
------

```console
$ helm install mongo ./mongo-standalone \
  --set credentials.rootUsername=<your-username> \
  --set credentials.rootPassword=<your-secure-password>
```

use default connection string to connect
```
mongodb://<username>:<password>@<host>:<port>/
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

## Secure Installation

### Option 1: Using --set flags
```bash
helm install mongo ./mongo-standalone \
  --set credentials.rootUsername=<your-username> \
  --set credentials.rootPassword=<your-secure-password>
```

### Option 2: Using Kubernetes Secrets
```bash
# Create secret
kubectl create secret generic mongo-credentials \
  --from-literal=username=<your-username> \
  --from-literal=password=<your-secure-password>

# Reference in values or use --set
helm install mongo ./mongo-standalone \
  --set credentials.rootUsername=<your-username> \
  --set credentials.rootPassword=<your-secure-password>
```

### Generate Secure Credentials
```bash
# Generate username
echo "mongouser_$(openssl rand -hex 4)"

# Generate password
openssl rand -base64 32
```

## Security Best Practices

- Use strong, randomly generated passwords (minimum 32 characters)
- Rotate credentials regularly (every 90 days minimum)
- Use external secret management for production deployments
- Enable authentication and authorization in production
- See [../../SECURITY.md](../../SECURITY.md) for detailed security guidance

Legal Notices
-------------

https://github.com/docker-library/mongo/blob/master/LICENSE
