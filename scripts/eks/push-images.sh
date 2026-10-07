#!/bin/bash
set -e

usage() {
  echo "Usage:"
  echo "  $0 [--tag <image-tag>] <registry-url> [image-name] [images-dir]"
  echo "  $0 [--tag <image-tag>] <registry-url> [images-dir]"
}

image_tag="latest"
while [ $# -gt 0 ]; do
  case "$1" in
    -t|--tag)
      if [ -z "${2:-}" ]; then
        echo "Image tag value is missing."
        usage
        exit 1
      fi
      image_tag="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unsupported option: $1"
      usage
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

if [ -z "$1" ]; then
  echo "Registry URL does not specify."
  usage
  exit 1
fi

registry_url="$1"
shift
image_name=""
images_dir="$PWD"

normalize_dir_path() {
  local dir="$1"
  if [ -d "$dir" ]; then
    echo "$dir"
    return 0
  fi

  if [[ "$dir" =~ ^/mnt/([a-zA-Z])/(.*)$ ]]; then
    local drive="${BASH_REMATCH[1],,}"
    local rest="${BASH_REMATCH[2]}"
    local git_bash_style="/$drive/$rest"
    if [ -d "$git_bash_style" ]; then
      echo "$git_bash_style"
      return 0
    fi
  fi

  return 1
}

is_dir_like_arg() {
  case "$1" in
    */*|*\\*|?:/*|?:\\*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

if [ $# -eq 1 ]; then
  arg="$1"
  if normalized_dir="$(normalize_dir_path "$arg")"; then
    images_dir="$normalized_dir"
  elif is_dir_like_arg "$arg"; then
    images_dir="$arg"
  else
    image_name="$arg"
  fi
elif [ $# -ge 2 ]; then
  image_name="$1"
  arg="$2"
  if normalized_dir="$(normalize_dir_path "$arg")"; then
    images_dir="$normalized_dir"
  else
    images_dir="$arg"
  fi
fi

if [ ! -d "$images_dir" ]; then
  echo "Images directory not found: $images_dir"
  exit 1
fi

images_map="resource-service:resource-service spatial-platform-ux-frontend:spatial-platform-ux-frontend composite-service:composite-service data-service:data-service private-sdk-mcp:private-sdk-mcp mapping-service:mapping-service feature-service:feature-service tiling-service:tiling-service samples-data:samples-data"
selected_images="$images_map"

if [ -n "$image_name" ]; then
  selected_images=""
  for pair in $images_map; do
    tar_name="${pair%%:*}"
    image_repo="${pair##*:}"
    if [ "$image_name" = "$tar_name" ] || [ "$image_name" = "$image_repo" ]; then
      selected_images="$pair"
      break
    fi
  done

  if [ -z "$selected_images" ]; then
    echo "Unsupported image name: $image_name"
    echo "Supported values:"
    for pair in $images_map; do
      echo "  ${pair%%:*}"
      if [ "${pair%%:*}" != "${pair##*:}" ]; then
        echo "  ${pair##*:}"
      fi
    done
    exit 1
  fi
fi

for pair in $selected_images; do
  tar_name="${pair%%:*}"
  image_repo="${pair##*:}"
  tar_path="$images_dir/$tar_name.tar"
  if [ ! -f "$tar_path" ]; then
    echo "Image tar file not found: $tar_path"
    exit 1
  fi

  echo ">>>load $tar_name image"
  docker load -i "$tar_path"
  docker tag "$image_repo:latest" "$registry_url/$image_repo:$image_tag"
  docker push "$registry_url/$image_repo:$image_tag"
  echo -e "<<<image loaded\n"
done

echo "Images pushed to artifact registry successfully."
