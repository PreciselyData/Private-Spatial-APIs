# Precisely Private Spatial APIs Setup on Local Docker Desktop

The Private Spatial APIs can be setup locally for test purpose.

## ⚠️ SECURITY WARNING

**DO NOT use hardcoded credentials!** This deployment requires you to set environment variables for OAuth2 client secrets before starting the services.

## Step 0: Configure Environment Variables

Before running docker-compose, you **must** set required environment variables:

### Windows PowerShell:
```powershell
$env:OAUTH2_CLIENT_SECRET = "your-secure-client-secret"
$env:IMAGE_REGISTRY = "localhost:5000"
$env:TAG = "latest"
$env:SPATIAL_PATH = "C:\path\to\spatial\data"
```

### Windows Command Prompt:
```cmd
set OAUTH2_CLIENT_SECRET=your-secure-client-secret
set IMAGE_REGISTRY=localhost:5000
set TAG=latest
set SPATIAL_PATH=C:\path\to\spatial\data
```

### Linux/macOS:
```bash
export OAUTH2_CLIENT_SECRET="your-secure-client-secret"
export IMAGE_REGISTRY="localhost:5000"
export TAG="latest"
export SPATIAL_PATH="/path/to/spatial/data"
```

### Using .env File (Recommended for Development)

1. Copy the example environment file:
   ```bash
   cp ../.env.example .env
   ```

2. Edit `.env` file with your values:
   ```properties
   IMAGE_REGISTRY=localhost:5000
   TAG=latest
   SPATIAL_PATH=/path/to/your/spatial/data
   OAUTH2_CLIENT_SECRET=your-secure-client-secret
   ```

3. **IMPORTANT**: Add `.env` to your `.gitignore` to prevent committing secrets!

### Generate Secure Client Secret
```bash
# Generate a secure OAuth2 client secret
openssl rand -hex 32
```

## Step 1: Download Reference Data and Required Docker Images

The docker files can be downloaded from either Precisely's Data Portfolio or [Data Integrity Suite](https://cloud.precisely.com/). For information about Precisely's Data Portfolio,
see the [Precisely Data Guide](https://dataguide.precisely.com/) where you can also sign up for a free account and
access software, reference data and docker files available in [Precisely Data Experience](https://data.precisely.com/).

After download, the docker images need to be pushed to a container registry. If you don't have a container registry, you can create one for testing as shown below:
   ```
   docker run -d -p 5000:5000 --restart=always --name registry registry:2.7
   ```
Then you can use a script [push-images](../scripts/aks/push-images.sh) to push the docker images to container registry.
> Note: Unzip the downloaded docker images to a directory <spatial_analytics_docker_images_dir> so that it contains tar files.

Open a shell on you local system and execute the following steps.
Run the shell script to push images to Azure Container Registry:
```shell
cd <spatial_analytics_docker_images_dir>
chmod a+x ~/Private-Spatial-APIs/scripts/aks/push-images.sh
~/Private-Spatial-APIs/scripts/aks/push-images.sh <container_registry_url>
```
You can also load images one by one if there's no enough disk space available.
There are six docker images which will be pushed to container registry:
1. feature-service
2. mapping-service
3. tiling-service
4. namedresource-service
5. spatialmanager-service
6. samples-data

Upload images one by one:
```shell
~/Private-Spatial-APIs/scripts/aks/push-images.sh <container_registry_url>  <tar file name without ext>
```


## Step 2: Running Service Locally

1. **Configure environment file**

   While building docker image locally, configure environment file to reference local image registry. Update _.env_ file in
      `docker-compose` folder with environment variable referencing image registry.
   ```properties
   IMAGE_REGISTRY=<container_registry_url>
   OAUTH2_CLIENT_SECRET=<your-secure-client-secret>
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

## Security Best Practices

- Never commit `.env` files to version control
- Generate strong, random secrets for all credentials
- Rotate secrets regularly
- For production deployments, use Kubernetes Secrets or external secret management systems
- See [../SECURITY.md](../SECURITY.md) for comprehensive security guidance

## References

- [Sample API Usage](../charts/private-spatial-apis/README.md)
- [Security Guide](../SECURITY.md)

[🔗 Return to `Table of Contents` 🔗](../README.md##)