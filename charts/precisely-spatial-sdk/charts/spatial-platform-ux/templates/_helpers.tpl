{{/*
Expand the name of the chart.
*/}}
{{- define "spatial-platform-ux.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "spatial-platform-ux.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "spatial-platform-ux.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Resolve the registry URL for spatial-platform-ux.
Uses global.registry.url when provided by the umbrella chart.
If the global URL contains the spatial-web-framework path, replace
"location-intelligence/spatial/spatial-web-framework" with
"cloud/di-suite/ui/spatial" for the UI image path.
Falls back to chart-local registry.url when global is not provided.
*/}}
{{- define "spatial-platform-ux.registryUrl" -}}
{{- $registryUrl := .Values.registry.url -}}
{{- with .Values.global -}}
{{- with .registry -}}
{{- with .url -}}
{{- $globalUrl := . -}}
{{- if contains "location-intelligence/spatial/spatial-web-framework" $globalUrl -}}
{{- $registryUrl = (replace "location-intelligence/spatial/spatial-web-framework" "cloud/di-suite/ui/spatial" $globalUrl) -}}
{{- else -}}
{{- $registryUrl = $globalUrl -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- $registryUrl -}}
{{- end -}}

{{/*
Resolve the image tag.
Inherits global.registry.tag when deployed via the umbrella chart for unified
versioning across all services, falls back to the chart-local registry.tag.
*/}}
{{- define "spatial-platform-ux.imageTag" -}}
{{- if .Values.global -}}
{{- .Values.global.registry.tag | default .Values.registry.tag -}}
{{- else -}}
{{- .Values.registry.tag -}}
{{- end -}}
{{- end -}}

{{/*
Resolve a component's pipeline image name (without the registry URL prefix).
If the tag is not "latest" and the last path segment of the global registry URL
is "spatial-web-framework" or "spatial-analytics", the image is published under
a "dev" sub-path: {imageName}/dev:{tag}.
Otherwise, the normal image reference is used: {imageName}:{tag}.
Usage: {{ include "platform.pipelineImageName" (dict "root" . "imageName" "resource-service") }}
*/}}
{{- define "platform.pipelineImageName" -}}
{{- $root := .root -}}
{{- $imageName := .imageName -}}
{{- $url := $root.Values.global.registry.url -}}
{{- $tag := $root.Values.global.registry.tag -}}
{{- $parts := $url | splitList "/" -}}
{{- $last := last $parts -}}
{{- if and (ne $tag "latest") (or (eq $last "spatial-web-framework") (eq $last "spatial-analytics")) -}}
{{- printf "%s/dev:%s" $imageName $tag -}}
{{- else -}}
{{- printf "%s:%s" $imageName $tag -}}
{{- end -}}
{{- end }}
