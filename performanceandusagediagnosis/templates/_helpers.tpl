{{/*
Expand the name of the chart.
*/}}
{{- define "enabler.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "enabler.fullname" -}}
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
{{- define "enabler.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Cilium Multi-cluster global service annotations.
*/}}
{{- define "globalServiceAnnotations" -}}
io.cilium/global-service: "true"
io.cilium/service-affinity: remote
{{- end }}

{{/*
Name of the component server.
*/}}
{{- define "server.name" -}}
{{- printf "%s-server" (include "enabler.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified component server name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "server.fullname" -}}
{{- printf "%s-server" (include "enabler.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Component server labels.
*/}}
{{- define "server.labels" -}}
helm.sh/chart: {{ include "enabler.chart" . }}
{{ include "server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Component server selector labels.
*/}}
{{- define "server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "enabler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
enabler: {{ .Chart.Name }}
app.kubernetes.io/component: server
isMainInterface: "yes"
tier: {{ .Values.server.tier }}
{{- end }}

{{/*
Name of the component alertmanager.
*/}}
{{- define "alertmanager.name" -}}
{{- printf "%s-alertmanager" (include "enabler.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified component alertmanager name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "alertmanager.fullname" -}}
{{- printf "%s-alertmanager" (include "enabler.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Component alertmanager labels.
*/}}
{{- define "alertmanager.labels" -}}
helm.sh/chart: {{ include "enabler.chart" . }}
{{ include "alertmanager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Component alertmanager selector labels.
*/}}
{{- define "alertmanager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "enabler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
enabler: {{ .Chart.Name }}
app.kubernetes.io/component: alertmanager
isMainInterface: "no"
tier: {{ .Values.alertmanager.tier }}
{{- end }}


{{/*
Name of the component kubestatemetrics.
*/}}
{{/*
{{- define "kubestatemetrics.name" -}}
{{- printf "%s-kubestatemetrics" (include "enabler.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
*/}}
{{/*
Create a default fully qualified component kubestatemetrics name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{/*
{{- define "kubestatemetrics.fullname" -}}
{{- printf "%s-kubestatemetrics" (include "enabler.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
*/}}

{{/*
Component kubestatemetrics labels.
*/}}
{{/*
{{- define "kubestatemetrics.labels" -}}
helm.sh/chart: {{ include "enabler.chart" . }}
{{ include "kubestatemetrics.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
*/}}
{{/*
Component kubestatemetrics selector labels.
*/}}
{{/*
{{- define "kubestatemetrics.selectorLabels" -}}
app.kubernetes.io/name: {{ include "enabler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
enabler: {{ .Chart.Name }}
app.kubernetes.io/component: kubestatemetrics
isMainInterface: "no"
tier: {{ .Values.kubestatemetrics.tier }}
{{- end }}
*/}}

{{/*
Name of the component prometheusesadapter.
*/}}
{{- define "prometheusesadapter.name" -}}
{{- printf "%s-prometheusesadapter" (include "enabler.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified component prometheusesadapter name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prometheusesadapter.fullname" -}}
{{- printf "%s-prometheusesadapter" (include "enabler.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Component prometheusesadapter labels.
*/}}
{{- define "prometheusesadapter.labels" -}}
helm.sh/chart: {{ include "enabler.chart" . }}
{{ include "prometheusesadapter.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Component prometheusesadapter selector labels.
*/}}
{{- define "prometheusesadapter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "enabler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
enabler: {{ .Chart.Name }}
app.kubernetes.io/component: prometheusesadapter
isMainInterface: "no"
tier: {{ .Values.prometheusesadapter.tier }}
{{- end }}

{{/*
Name of the component targetapi.
*/}}
{{- define "targetapi.name" -}}
{{- printf "%s-targetapi" (include "enabler.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified component targetapi name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "targetapi.fullname" -}}
{{- printf "%s-targetapi" (include "enabler.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Component targetapi labels.
*/}}
{{- define "targetapi.labels" -}}
helm.sh/chart: {{ include "enabler.chart" . }}
{{ include "targetapi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Component targetapi selector labels.
*/}}
{{- define "targetapi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "enabler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
enabler: {{ .Chart.Name }}
app.kubernetes.io/component: targetapi
isMainInterface: "no"
tier: {{ .Values.targetapi.tier }}
{{- end }}

