# Private Spatial APIs
This Helm chart is an umbrella Helm chart for installing as many of the services as possible at once.

The following Kubernetes objects are created:

* feature-service
* mapping-service
* namedresource-service
* spatialmanager-service
* tiling-service

## Pre-requisites
A MongoDB (Replica Set) is required to persist named resources. 
MongoDB is configured with this Helm variables:

| Value                                  | Description                 |
|----------------------------------------|-----------------------------|
| `repository.mongodb.url`               | A connection string         |

More details on Private Spatial APIs usage can be found [here](https://help.precisely.com/r/Precisely-Data-Integrity-Suite/Latest/en-US/Private-Spatial-APIs-Guide/Services/REST-Services).
