[🔗 Return to `Table of Contents` 🔗](../../../README.md#guides)

# Upgrade Guide

## Step 1 - Prepare Your Changes

This guide is applicable in the following situations:

1. Upgrading to newer versions of the chart.
3. Upgrading to the newer version of Private Spatial APIs releases.
4. Applying changes to `values.yaml` file.

## Step 2 - Apply your changes

```shell
## pull updates from the helm repository
helm repo update

## apply the changes values.yaml file AND upgrade the chart to newer version
helm upgrade --install spatial-analytics ./charts/private-spatial-apis \
--dependency-update \
--namespace spatial-analytics --create-namespace \
--version [updated-version]
```

> 🟥 __Warning__ 🟥
>
> Always pin the `--version` so you don't unexpectedly update chart versions!