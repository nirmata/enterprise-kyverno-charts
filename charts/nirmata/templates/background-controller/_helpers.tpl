{{/* vim: set filetype=mustache: */}}

{{- define "kyverno.background-controller.name" -}}
{{ template "kyverno.name" . }}-background-controller
{{- end -}}

{{- define "kyverno.background-controller.labels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.labels.common" .)
  (include "kyverno.background-controller.matchLabels" .)
) -}}
{{- end -}}

{{- define "kyverno.background-controller.matchLabels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.matchLabels.common" .)
  (include "kyverno.labels.component" "background-controller")
) -}}
{{- end -}}

{{- define "kyverno.background-controller.image" -}}
{{- $imageRegistry := default .image.registry .globalRegistry -}}
{{- $fipsEnabled := .fipsEnabled -}}
{{- if $imageRegistry -}}
    {{- if $fipsEnabled -}}
      {{ .image.registry }}/{{ required "An image repository is required" .image.repository }}-fips:v1.12.6-n4k.nirmata.3-rc3
    {{- else -}}
      {{ $imageRegistry }}/{{ required "An image repository is required" .image.repository }}:{{ default .defaultTag .image.tag }}
    {{- end -}}
{{- else -}}
  {{ required "An image repository is required" .image.repository }}:{{ default .defaultTag .image.tag }}
{{- end -}}
{{- end -}}

{{- define "kyverno.background-controller.roleName" -}}
{{ include "kyverno.fullname" . }}:background-controller
{{- end -}}

{{- define "kyverno.background-controller.serviceAccountName" -}}
{{- if .Values.backgroundController.rbac.create -}}
    {{ default (include "kyverno.background-controller.name" .) .Values.backgroundController.rbac.serviceAccount.name }}
{{- else -}}
    {{ required "A service account name is required when `rbac.create` is set to `false`" .Values.backgroundController.rbac.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "kyverno.background-controller.serviceAnnotations" -}}
  {{- template "kyverno.annotations.merge" (list
    (toYaml .Values.customAnnotations)
    (toYaml .Values.admissionController.service.annotations)
  ) -}}
{{- end -}}

{{- define "kyverno.background-controller.caCertificatesConfigMapName" -}}
{{ printf "%s-ca-certificates" (include "kyverno.background-controller.name" .) }}
{{- end -}}

{{- define "kyverno.background-controller.serviceAccountAnnotations" -}}
  {{- template "kyverno.annotations.merge" (list
    (toYaml .Values.customAnnotations)
    (toYaml .Values.backgroundController.rbac.serviceAccount.annotations)
  ) -}}
{{- end -}}