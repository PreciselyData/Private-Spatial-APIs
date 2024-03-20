## Prepare database for repository

A Database (PostgreSQL or MSSQL Server) instance is used to persistent repository content. If you have an external instance available, just collect the connection string and credentials for further use. You can also follow the steps below to install a postgres database to the EKS cluster. For the performance reason, keep the database instance as close to the cluster as possible.

### Install a postgres database instance by helm

Install postgres (reference to [Setup helm repository](deploy-spatial-services.md) in Step 6)
```
helm install postgis spatial/postgis-standalone --version 1.0.0 -n spatial
```

This will install a postgre single node instance with the following information (default)
```
connection uri = jdbc:postgresql://postgis:5432/jackrabbit_db?currentSchema=public
username: "jackrabbit_user"
password: "jackrabbit_user"
```

### [Next Step](enable-security.md)
