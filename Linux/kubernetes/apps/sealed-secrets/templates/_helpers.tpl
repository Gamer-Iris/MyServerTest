{{/*
Generate the full name of the application
*/}}
{{- define "sealed-secrets.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the name of the chart
*/}}
{{- define "sealed-secrets.name" -}}
{{- .Chart.Name -}}
{{- end -}}
