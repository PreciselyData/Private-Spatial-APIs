# Precisely Cloudnative-Spatial-Analytics-helm Service Setup on Local Docker Desktop

The Spatial-Analytics application can be setup locally for test purpose.

## Step 1: Download Reference Data and Required Docker Images

The docker files can be downloaded from either Precisely's Data Portfolio or [Data Integrity Suite](https://cloud.precisely.com/). For information about Precisely's Data Portfolio,
see the [Precisely Data Guide](https://dataguide.precisely.com/) where you can also sign up for a free account and
access software, reference data and docker files available in [Precisely Data Experience](https://data.precisely.com/).

For more information on downloading the docker images, follow [this section](../docs/guides/aks/README.md#3-download-spatial-analytics-images).

> Note : If you don't have a container registry, you can create one for testing as shown below:
   ```
   docker run -d -p 5000:5000 --restart=always --name registry registry:2.7
   ```

## Step 2: Running Service Locally

1. **Configure environment file**

   While building docker image locally, configure environment file to reference local image registry. Update _.env_ file in
      `docker-compose` folder with environment variable referencing image registry.
   ```properties
   IMAGE_REGISTRY=<container_registry_url>
   ```

   If customizing the copy sample data location on the system, please provide your desired path for the `SPATIAL_PATH` variable in the .env file. Otherwise, it will default to the path specified in the .env file.

2. **service to start using docker compose file**

   If you *always* want all the service to start you can run:
   ```
   docker compose up
   ```
3. **Cleanup of local services**

   Regardless of any above method of running the services locally below cleanup command will be same.

   ```shell
   docker compose down
   ```

## References

- [Sample API Usage](../charts/spatial-cloud-native/README.md)

[🔗 Return to `Table of Contents` 🔗](../README.md##)