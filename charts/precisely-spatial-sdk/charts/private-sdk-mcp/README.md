# private-sdk-mcp

Helm chart for deploying the Private Spatial MCP service.

## Requirements

The target namespace must contain `regcred-gitlab` (or the value of
`image.pullSecret`) for pulling the MCP image.

Set `image.tag` to the immutable tag published by the `private-sdk-mcp` GitLab
pipeline. The chart derives the unified Spatial platform URL from
`global.ingress.host` and sends Spatial API requests to that host.

The MCP client must send its short-lived bearer token in the `Authorization`
header. The service forwards that header to the Spatial APIs and does not use a
static Kubernetes token Secret.

When `ingress.enabled` is true, the chart exposes the MCP endpoint at `/mcp`
using `global.ingress.host` and `global.ingress.ingressClassName`.