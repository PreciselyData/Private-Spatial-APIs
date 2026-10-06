#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Registry URL does not specify."
  exit 1
fi

if ! [ -z "$2" ]; then
  echo ">>>load $2 image"
  docker load -i $2.tar
  docker tag $2:latest $1/$2:latest
  docker push $1/$2:latest
  echo -e "<<<image loaded\n"
  exit 0
fi

echo ">>>load resource-service image"
docker load -i resource-service.tar
docker tag resource-service:latest $1/resource-service:latest
docker push $1/resource-service:latest
echo -e "<<<image loaded\n"

echo ">>>load spatial-platform-ux image"
docker load -i spatial-platform-ux.tar
docker tag spatial-platform-ux:latest $1/spatial-platform-ux:latest
docker push $1/spatial-platform-ux:latest
echo -e "<<<image loaded\n"

echo ">>>load composite-service image"
docker load -i composite-service.tar
docker tag composite-service:latest $1/composite-service:latest
docker push $1/composite-service:latest
echo -e "<<<image loaded\n"

echo ">>>load data-service image"
docker load -i data-service.tar
docker tag data-service:latest $1/data-service:latest
docker push $1/data-service:latest
echo -e "<<<image loaded\n"

echo ">>>load private-sdk-mcp image"
docker load -i private-sdk-mcp.tar
docker tag private-sdk-mcp:latest $1/private-sdk-mcp:latest
docker push $1/private-sdk-mcp:latest
echo -e "<<<image loaded\n"

echo ">>>load mapping-service image"
docker load -i mapping-service.tar
docker tag mapping-service:latest $1/mapping-service:latest
docker push $1/mapping-service:latest
echo -e "<<<image loaded\n"

echo ">>>load feature-service image"
docker load -i feature-service.tar
docker tag feature-service:latest $1/feature-service:latest
docker push $1/feature-service:latest
echo -e "<<<image loaded\n"

echo ">>>load tiling-service image"
docker load -i tiling-service.tar
docker tag tiling-service:latest $1/tiling-service:latest
docker push $1/tiling-service:latest
echo -e "<<<image loaded\n"

echo ">>>load samples-data image"
docker load -i samples-data.tar
docker tag samples-data:latest $1/samples-data:latest
docker push $1/samples-data:latest
echo -e "<<<image loaded\n"
echo "Images pushed to artifact registry successfully."
