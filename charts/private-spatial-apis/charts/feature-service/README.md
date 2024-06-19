# feature-service
Helm chart for installing the feature-service into a Kubernetes cluster.

## Chart Values

| Value               | Description
|---------------------|---
| `registry.url`     | The URL to pull the image from.
| `registry.prefix`  | The suffix or subpath from `registry.url` to pull the image from.
| `registry.tag`     | The tag of the image to pull.
| `registry.secrets` | The name of the Secret installed in the Kubernetes cluster to use to pull the image with.
| `initReplicaCount`  | The value of the `spec.minReplicas` property of the `HorizontalPodAutoscaler`.
| `maxReplicaCount`   | The value of the `spec.maxReplicas` property of the `HorizontalPodAutoscaler`.
| `requestCPU`        | The value of the `spec.template.spec.containers.resources.requests.cpu` property.
| `requestMemory`     | The value of the `spec.template.spec.containers.resources.requests.memory` property.
| `limitCPU`          | The value of the `spec.template.spec.containers.resources.limits.cpu` property.
| `limitMemory`       | The value of the `spec.template.spec.containers.resources.limits.cpu` property.

## Requirements
The feature-service expects a PersistentVolumeClaim called data-volume-claim to already be installed in the cluster.