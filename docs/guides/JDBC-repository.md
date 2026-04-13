# JDBC-based repository

In addition to MongoDB, Private Spatial APIs resource repository is now able to store resources in any JDBC-compatible databases that gives you more options based on your environment requirements. It uses Spring Boot JPA to access a database.

## Considerations

| Repository Type | Suitable For | Considerations |
| --------------- | ------------ | -------------- |
| File-based | feature service only deployment, no SpatialManager | read only, small number of resources (<1000) |
| SQL Server | full deployment | read/write, middle number of resources (<5,000), less concurrent modification |
| PostgreSQL | full deployment | read/write, large number of resources (<20,000) |
| MongoDB | full deployment | read/write, large number of resources (>20,000) |

## Enable JDBC-based repository

The database should be prepared in advance. It should be as close to the service as possible to avoid network latency.

Helm chart deployment, set `repositoryFactory` to `JpaRepositoryFactory`. You can have credentials be part of the url, or add credentials separately.

```
helm install ..... --set "property.repositoryFactory=com.precisely.swp.repository.jpa.JpaRepositoryFactory" --set "repository.jdbc.url=<jdbc connection string>" --set "repository.jdbc.username=<username>" --set "repository.jdbc.password=<password>"
```

For some older version of SQL Server databases, you may also need to specify the database platform explicitly to avoid services failing to start.

```
helm install ..... --set "repository.jdbc.dialect=org.hibernate.dialect.SQLServerDialect"
```

After services start up, the required tables and index will be created automatically. Check the database to ensure the following tables are created.

```
  named_resource_document
  named_resource_document_type
  named_resource_document_reference 
  named_resource_document_searchable 
``` 

Also see: [Spring Data JPA](https://spring.io/projects/spring-data-jpa), [spring.datasource](https://docs.spring.io/spring-boot/appendix/application-properties/index.html)
