{{/*
Expand the name of the chart.
*/}}
{{- define "spring-petclinic.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "spring-petclinic.fullname" -}}
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
{{- define "spring-petclinic.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "spring-petclinic.labels" -}}
helm.sh/chart: {{ include "spring-petclinic.chart" . }}
{{ include "spring-petclinic.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "spring-petclinic.selectorLabels" -}}
app.kubernetes.io/name: {{ include "spring-petclinic.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "spring-petclinic.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "spring-petclinic.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Database specific helpers
*/}}
{{- define "spring-petclinic.database.name" -}}
{{- printf "%s-db" (include "spring-petclinic.fullname" .) }}
{{- end }}

{{- define "spring-petclinic.database.fullname" -}}
{{- if .Values.database.fullnameOverride }}
{{- .Values.database.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-db" (include "spring-petclinic.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "spring-petclinic.database.labels" -}}
helm.sh/chart: {{ include "spring-petclinic.chart" . }}
app.kubernetes.io/name: {{ include "spring-petclinic.database.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "spring-petclinic.database.selectorLabels" -}}
app.kubernetes.io/name: {{ include "spring-petclinic.database.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
PetClinic specific helpers
*/}}
{{- define "spring-petclinic.app.name" -}}
{{- printf "%s-app" (include "spring-petclinic.fullname" .) }}
{{- end }}

{{- define "spring-petclinic.app.fullname" -}}
{{- if .Values.petclinic.fullnameOverride }}
{{- .Values.petclinic.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-app" (include "spring-petclinic.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "spring-petclinic.app.labels" -}}
helm.sh/chart: {{ include "spring-petclinic.chart" . }}
app.kubernetes.io/name: {{ include "spring-petclinic.app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "spring-petclinic.app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "spring-petclinic.app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }} 