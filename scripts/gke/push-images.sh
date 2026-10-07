#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Registry URL does not specify."
  echo "Usage:"
  echo "  $0 <registry-url> [image-name] [images-dir]"
  echo "  $0 <registry-url> [images-dir]"
  exit 1
fi

registry_url="$1"
arg2="${2:-}"
arg3="${3:-}"
image_name=""
images_dir="$PWD"

if [ -n "$arg2" ] && [ -d "$arg2" ]; then
  images_dir="$arg2"
else
  image_name="$arg2"
  if [ -n "$arg3" ]; then
    images_dir="$arg3"
  fi
fi

if [ ! -d "$images_dir" ]; then
  echo "Images directory not found: $images_dir"
  exit 1
fi

images="mapping-service feature-service tiling-service resource-service spatial-platform-ux composite-service data-service private-sdk-mcp samples-data"
if [ -n "$image_name" ]; then
  images="$image_name"
fi

for image in $images; do
  tar_path="$images_dir/$image.tar"
  if [ ! -f "$tar_path" ]; then
    echo "Image tar file not found: $tar_path"
    exit 1
  fi

  echo ">>>load $image image"
  docker load -i "$tar_path"
  docker tag "$image:latest" "$registry_url/$image:latest"
  docker push "$registry_url/$image:latest"
  echo -e "<<<image loaded\n"
done
echo "Images pushed to artifact registry successfully."
