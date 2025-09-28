{{/*
Expand the name of the chart.
*/}}
{{- define "mem0.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mem0.fullname" -}}
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
{{- define "mem0.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mem0.labels" -}}
helm.sh/chart: {{ include "mem0.chart" . }}
{{ include "mem0.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mem0.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mem0.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mem0.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mem0.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the image name
*/}}
{{- define "mem0.image" -}}
{{- if .Values.image.registry }}
{{- printf "%s/%s:%s" .Values.image.registry .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- else }}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- end }}
{{- end }}

{{/*
PostgreSQL host
*/}}
{{- define "mem0.postgresql.host" -}}
{{- if .Values.postgresql.enabled }}
{{- printf "%s-postgresql" (include "mem0.fullname" .) }}
{{- else }}
{{- .Values.config.postgresql.host }}
{{- end }}
{{- end }}

{{/*
PostgreSQL secret name - uses standard dependency chart secret
*/}}
{{- define "mem0.postgresql.secretName" -}}
{{- if .Values.postgresql.enabled }}
{{- printf "%s-postgresql" (include "mem0.fullname" .) }}
{{- else if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecret }}
{{- else }}
{{- printf "%s-secrets" (include "mem0.fullname" .) }}
{{- end }}
{{- end }}

{{/*
PostgreSQL password key - uses Bitnami standard key
*/}}
{{- define "mem0.postgresql.passwordKey" -}}
{{- if .Values.postgresql.enabled }}
{{- "password" }}
{{- else if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecretKeys.postgresqlPassword }}
{{- else }}
{{- "POSTGRES_PASSWORD" }}
{{- end }}
{{- end }}

{{/*
Neo4j host
*/}}
{{- define "mem0.neo4j.host" -}}
{{- if .Values.neo4j.enabled }}
{{- printf "%s-neo4j" (include "mem0.fullname" .) }}
{{- else }}
{{- .Values.config.neo4j.uri | regexFind "://([^:]+)" | regexReplaceAll "://([^:]+)" "${1}" }}
{{- end }}
{{- end }}

{{/*
Neo4j secret name - uses standard dependency chart secret
*/}}
{{- define "mem0.neo4j.secretName" -}}
{{- if .Values.neo4j.enabled }}
{{- printf "%s-neo4j-auth" (include "mem0.fullname" .) }}
{{- else if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecret }}
{{- else }}
{{- printf "%s-secrets" (include "mem0.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Neo4j password key - uses Neo4j standard key
*/}}
{{- define "mem0.neo4j.passwordKey" -}}
{{- if .Values.neo4j.enabled }}
{{- "neo4j-password" }}
{{- else if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecretKeys.neo4jPassword }}
{{- else }}
{{- "NEO4J_PASSWORD" }}
{{- end }}
{{- end }}

{{/*
PostgreSQL connection string
*/}}
{{- define "mem0.postgresql.connectionString" -}}
{{- printf "postgresql://%s:%s@%s:%d/%s" .Values.config.postgresql.username "$(POSTGRES_PASSWORD)" (include "mem0.postgresql.host" .) (.Values.config.postgresql.port | int) .Values.config.postgresql.database }}
{{- end }}

{{/*
Neo4j connection URI
*/}}
{{- define "mem0.neo4j.connectionUri" -}}
{{- if .Values.neo4j.enabled }}
{{- printf "bolt://%s:7687" (include "mem0.neo4j.host" .) }}
{{- else }}
{{- .Values.config.neo4j.uri }}
{{- end }}
{{- end }}

{{/*
Secret name for secrets
*/}}
{{- define "mem0.secretName" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecret }}
{{- else }}
{{- printf "%s-secrets" (include "mem0.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Secret key for OpenAI API key
*/}}
{{- define "mem0.secretKey.openaiApiKey" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecretKeys.openaiApiKey }}
{{- else }}
{{- "OPENAI_API_KEY" }}
{{- end }}
{{- end }}

{{/*
Secret key for PostgreSQL password
*/}}
{{- define "mem0.secretKey.postgresqlPassword" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecretKeys.postgresqlPassword }}
{{- else }}
{{- "POSTGRES_PASSWORD" }}
{{- end }}
{{- end }}

{{/*
Secret key for Neo4j password
*/}}
{{- define "mem0.secretKey.neo4jPassword" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecretKeys.neo4jPassword }}
{{- else }}
{{- "NEO4J_PASSWORD" }}
{{- end }}
{{- end }}