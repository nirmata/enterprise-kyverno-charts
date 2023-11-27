{{/* vim: set filetype=mustache: */}}

{{- define "kyverno.rbac.labels.admin" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.labels.common" .)
  (include "kyverno.rbac.matchLabels" .)
  "rbac.authorization.k8s.io/aggregate-to-admin: 'true'"
) -}}
{{- end -}}

{{- define "kyverno.rbac.labels.view" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.labels.common" .)
  (include "kyverno.rbac.matchLabels" .)
  "rbac.authorization.k8s.io/aggregate-to-view: 'true'"
) -}}
{{- end -}}

{{- define "kyverno.rbac.matchLabels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.matchLabels.common" .)
  (include "kyverno.labels.component" "rbac")
) -}}
{{- end -}}

{{- define "kyverno.rbac.roleName" -}}
{{ include "kyverno.fullname" . }}:rbac
{{- end -}}

{{- define "kyverno.serviceAccountName" -}}
{{- if .Values.admissionController.rbac.create -}}
    {{ default (include "kyverno.admission-controller.name" .) .Values.admissionController.rbac.serviceAccount.name }}
{{- else -}}
    {{ required "A service account name is required when `rbac.create` is set to `false`" .Values.admissionController.rbac.serviceAccount.name }}
{{- end -}}
{{- end -}}
