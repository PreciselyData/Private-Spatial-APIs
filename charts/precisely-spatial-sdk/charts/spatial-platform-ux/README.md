# Spatial Platform UX Helm Chart

Helm chart for deploying the **Spatial Platform UX Frontend** (Next.js) to Kubernetes.

## Prerequisites

- Kubernetes 1.24+
- Helm 3.x
- NGINX Ingress Controller (or equivalent)
- Image pull secret for the container registry

## Quick Start

```bash
# Install with default values
helm install spatial-platform-ux ./charts/spatial-platform-ux \
  --namespace spatial-analytics

# Install with custom values
helm install spatial-platform-ux ./charts/spatial-platform-ux \
  --namespace spatial-analytics \
  -f charts/spatial-platform-ux/values-eks-test.yaml
```

## Configuration

All configuration is exposed via `values.yaml`. Key parameters:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `registry.url` | Container image registry | `jfrog.precisely.engineering/...` |
| `registry.tag` | Image tag | `latest` |
| `registry.secrets` | Image pull secret name | `regcred-jfrog` |
| `initReplicaCount` | Number of replicas | `1` |
| `maxReplicaCount` | Max replicas for HPA | `4` |
| `requestCPU` | CPU request | `100m` |
| `requestMemory` | Memory request | `256Mi` |
| `limitMemory` | Memory limit | `512Mi` |
| `ingress.host` | Ingress hostname | `""` |
| `env.PLATFORM_TILING_URL` | Tiling service URL | `http://tiling-service:8080` |
| `env.PLATFORM_MAPPING_URL` | Mapping service URL | `http://mapping-service:8080` |
| `env.PLATFORM_FEATURE_URL` | Feature service URL | `http://feature-service:8080` |
| `env.PLATFORM_RESOURCE_URL` | Resource service URL | `http://resource-service:8080` |

### Shared Configuration

The chart loads environment variables from the `spatial-config` ConfigMap and Secret
(same as feature-service, mapping-service, etc.). Any values in those resources are
automatically available to the frontend container.

### Global Overrides (Umbrella Chart)

When deployed as a sub-chart of `spatial-cloud-native`, global values override local ones:

```yaml
global:
  registry:
    url: "jfrog.precisely.engineering/docker-virtual/..."
    tag: "1.0.0"
    secrets: "regcred-jfrog"
  ingress:
    host: "spatial.eks-test.precisely.engineering"
    ingressClassName: "nginx"
```

## Upgrading

```bash
helm upgrade spatial-platform-ux ./charts/spatial-platform-ux \
  --namespace spatial-analytics \
  -f charts/spatial-platform-ux/values-eks-test.yaml
```

## Uninstalling

```bash
helm uninstall spatial-platform-ux --namespace spatial-analytics
```

## Integration with Spatial Cloud Native Helm Chart

This chart is designed to be included as a dependency in the `spatial-cloud-native` umbrella chart. Add to the parent `Chart.yaml`:

```yaml
dependencies:
  - name: spatial-platform-ux
    version: "0.1.0"
    repository: "file://../spatial-platform-ux"
```

The `global.*` values will automatically override `registry` and `ingress` settings.
