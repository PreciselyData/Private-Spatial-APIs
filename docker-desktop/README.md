# Precisely Cloudnative-Spatial-Analytics-helm Service Setup on Local Docker Desktop

The Spatial-Analytics application can be setup locally for test purpose.

## Step 1: Download Reference Data and Required Docker Images

The docker files can be downloaded from either Precisely's Data Portfolio or [Data Integrity Suite](https://cloud.precisely.com/). For information about Precisely's Data Portfolio,
see the [Precisely Data Guide](https://dataguide.precisely.com/) where you can also sign up for a free account and
access software, reference data and docker files available in [Precisely Data Experience](https://data.precisely.com/).

## Step 2: Running Service Locally

1. **Install Docker Desktop**

2. **To setup a local image registry**

   use the following command:
   ```
   docker run -d -p 5000:5000 --restart=always --name registry registry:2.7
   ```

3. **configure environment file**

   While building docker image locally, configure environment file to reference local image registry. Update _.env_ file in
      `docker-compose` folder with environment variable referencing image registry. Otherwise, the default registry will
      be our jfrog registry (jfrog.precisely.engineering):
   ```properties
   IMAGE_REGISTRY=localhost:5000
   ```

4. **Docker images pushed to a local image registry**

   There are six docker images which will be pushed to container registry:
   1. feature-service
   2. mapping-service
   3. tiling-service
   4. namedresource-service
   5. spatialmanager-service
   6. samples-data

   After download, the docker images need to be pushed to a container registry. Then you can use a script [push-images](./push-images.sh) to push the docker images to local image registry.

   > Note: You must provide the local path to the download tar file location of each images (with double back slashes)

   Run the shell script to push images to Local Image Registry:
   ```shell
   cd docker-desktop
   chmod a+x ./push-images.sh
   ./push-images.sh localhost:5000
   ```

5. **service to start using docker compose file**

   If you *always* want all the service to start you can run:
   ```
   docker compose up
   ```

## References

- [Sample API Usage](../charts/geo-addressing/README.md#geo-addressing-service-api-usage)

[🔗 Return to `Table of Contents` 🔗](../README.md#setup)