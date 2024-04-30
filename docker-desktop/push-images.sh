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

echo ">>>load spatialmanager-service image"
docker load -i <local path of the downloaded tar file>\\spatialmanager-service.tar
docker tag spatialmanager-service:latest $1/spatialmanager-service:latest
docker push $1/spatialmanager-service:latest
echo -e "<<<image loaded\n"

echo ">>>load namedresource-service image"
docker load -i <local path of the downloaded tar file>\\namedresource-service.tar
docker tag namedresource-service:latest $1/namedresource-service:latest
docker push $1/namedresource-service:latest
echo -e "<<<image loaded\n"

echo ">>>load mapping-service image"
docker load -i <local path of the downloaded tar file>\\mapping-service.tar
docker tag mapping-service:latest $1/mapping-service:latest
docker push $1/mapping-service:latest
echo -e "<<<image loaded\n"

echo ">>>load feature-service image"
docker load -i <local path of the downloaded tar file>\\feature-service.tar
docker tag feature-service:latest $1/feature-service:latest
docker push $1/feature-service:latest
echo -e "<<<image loaded\n"

echo ">>>load tiling-service image"
docker load -i <local path of the downloaded tar file>\\tiling-service.tar
docker tag tiling-service:latest $1/tiling-service:latest
docker push $1/tiling-service:latest
echo -e "<<<image loaded\n"

echo ">>>load samples-data image"
docker load -i <local path of the downloaded tar file>\\samples-data.tar
docker tag samples-data:latest $1/samples-data:latest
docker push $1/samples-data:latest
echo -e "<<<image loaded\n"
echo "Images pushed to artifact registry successfully."
