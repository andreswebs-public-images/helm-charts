{{/*
Expand the name of the chart.
*/}}
{{- define "app.name" -}}
{{- default $.Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app.fullname" -}}
{{- if $.Values.fullnameOverride }}
{{- $.Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default $.Chart.Name $.Values.nameOverride }}
{{- if contains $name $.Release.Name }}
{{- $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $.Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Define the version of the chart/application.
*/}}
{{- define "app.version" -}}
{{- $version := default "" $.Chart.AppVersion -}}
{{- regexReplaceAll "[^a-zA-Z0-9_\\.\\-]" $version "-" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app.chart" -}}
{{- printf "%s-%s" $.Chart.Name $.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Renders a value that contains a template.
Usage:
{{ include "app.tplvalues.render" ( dict "value" $.Values.path.to.the.Value "context" $) }}
*/}}
{{- define "app.tplvalues.render" -}}
{{- if typeIs "string" .value }}
{{- tpl .value .context }}
{{- else }}
{{- tpl (.value | toYaml) .context }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.fullname" . }}
app.kubernetes.io/instance: {{ $.Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "app.selectorLabels" . }}
{{- with include "app.version" . }}
app.kubernetes.io/version: {{ quote . }}
{{- end }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
app.kubernetes.io/part-of: {{ include "app.fullname" . }}
{{- end }}

{{/*
Allow the release namespace to be overridden
*/}}
{{- define "app.namespace" -}}
{{- default $.Release.Namespace $.Values.namespaceOverride -}}
{{- end -}}

{{/*
Create the name of the service account
*/}}
{{- define "app.serviceAccountName" -}}
{{- if $.Values.serviceAccount.create -}}
{{ default (include "app.fullname" .) $.Values.serviceAccount.name }}
{{- else -}}
{{ default "default" $.Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the main app image
*/}}
{{- define "app.image" -}}
{{- $repository := required "image.repository must be set" $.Values.image.repository -}}
{{- $image := $repository -}}
{{- if $.Values.image.digest -}}
{{- $image = printf "%s@%s" $repository $.Values.image.digest -}}
{{- else if $.Values.image.tag -}}
{{- $image = printf "%s:%s" $repository $.Values.image.tag -}}
{{- end -}}
{{ $image }}
{{- end -}}
