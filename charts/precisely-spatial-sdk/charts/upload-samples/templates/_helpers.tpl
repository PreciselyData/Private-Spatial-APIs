{{/*
Expand the name of the chart.
*/}}
{{- define "upload.samples.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "upload.samples.fullname" -}}
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
{{- define "upload.samples.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "upload.samples.labels" -}}
helm.sh/chart: {{ include "upload.samples.chart" . }}
{{ include "upload.samples.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "upload.samples.selectorLabels" -}}
app.kubernetes.io/name: {{ include "upload.samples.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "upload.samples.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "upload.samples.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

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
