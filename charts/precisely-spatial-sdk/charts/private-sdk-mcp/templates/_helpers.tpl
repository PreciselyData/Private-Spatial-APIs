{{/*
Resolve the global registry URL for the private-sdk-mcp image path.
*/}}
{{- define "private-sdk-mcp.globalRegistryUrl" -}}
{{- regexReplaceAll "/spatial-(web-framework|analytics)$" .Values.global.registry.url "/spatial-analytics/poc" -}}
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