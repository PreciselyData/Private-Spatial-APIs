[🔗 Return to `Table of Contents` 🔗](../../../README.md#guides)

# Uninstall Guide for AKS

To uninstall the Private Spatial APIs helm chart, run the following command:

```shell
## set the release-name & namespace (must be same as previously installed)
export RELEASE_NAME="spatial-analytics"
export RELEASE_NAMESPACE="spatial-analytics"

## uninstall the chart
helm uninstall \
  "$RELEASE_NAME" \
  --namespace "$RELEASE_NAMESPACE"
```