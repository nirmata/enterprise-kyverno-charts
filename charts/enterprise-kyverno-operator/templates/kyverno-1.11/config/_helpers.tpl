{{/* vim: set filetype=mustache: */}}

{{- define "kyverno.config.configMapName" -}}
{{- if .Values.kyverno.config.create -}}
    {{ default (include "kyverno.fullname" .) .Values.kyverno.config.name }}
{{- else -}}
    {{ required "A configmap name is required when `config.create` is set to `false`" .Values.kyverno.config.name }}
{{- end -}}
{{- end -}}

{{- define "kyverno.config.metricsConfigMapName" -}}
{{- if .Values.kyverno.metricsConfig.create -}}
    {{ default (printf "%s-metrics" (include "kyverno.fullname" .)) .Values.kyverno.metricsConfig.name }}
{{- else -}}
    {{ required "A configmap name is required when `metricsConfig.create` is set to `false`" .Values.kyverno.metricsConfig.name }}
{{- end -}}
{{- end -}}

{{- define "kyverno.config.labels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.labels.common" .)
  (include "kyverno.config.matchLabels" .)
) -}}
{{- end -}}

{{- define "kyverno.config.matchLabels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.matchLabels.common" .)
  (include "kyverno.labels.component" "config")
) -}}
{{- end -}}

{{- define "kyverno.config.resourceFilters" -}}
{{- $resourceFilters := .Values.kyverno.config.resourceFilters -}}
{{- if .Values.kyverno.config.excludeKyvernoNamespace -}}
  {{- $resourceFilters = prepend .Values.kyverno.config.resourceFilters (printf "[*/*,%s,*]" (include "kyverno.namespace" .)) -}}
{{- end -}}
{{- range $exclude := .Values.kyverno.config.resourceFiltersExcludeNamespaces -}}
  {{- range $filter := $resourceFilters -}}
    {{- if (contains (printf ",%s," $exclude) $filter) -}}
      {{- $resourceFilters = without $resourceFilters $filter -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- $resourceFilters = concat $resourceFilters .Values.config.resourceFiltersInclude -}}
{{- range $include := .Values.config.resourceFiltersIncludeNamespaces -}}
  {{- $resourceFilters = append $resourceFilters (printf "[*/*,%s,*]" $include) -}}
{{- end -}}
{{- range $resourceFilter := $resourceFilters }}
{{ tpl $resourceFilter $ }}
{{- end -}}
{{- end -}}

{{- define "kyverno.config.webhooks" -}}
{{- $excludeDefault := dict "key" "kubernetes.io/metadata.name" "operator" "NotIn" "values" (list (include "kyverno.namespace" .)) }}
{{- $newWebhook := list }}
{{- range $webhook := .Values.kyverno.config.webhooks }}
  {{- $namespaceSelector := default dict $webhook.namespaceSelector }}
  {{- $matchExpressions := default list $namespaceSelector.matchExpressions }}
  {{- $newNamespaceSelector := dict "matchLabels" $namespaceSelector.matchLabels "matchExpressions" (append $matchExpressions $excludeDefault) }}
  {{- $newWebhook = append $newWebhook (merge (omit $webhook "namespaceSelector") (dict "namespaceSelector" $newNamespaceSelector)) }}
{{- end }}
{{- $newWebhook | toJson }}
{{- end -}}

{{- define "kyverno.config.imagePullSecret" -}}
{{- printf "{\"auths\":{\"%s\":{\"auth\":\"%s\"}}}" .registry (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end -}}

{{- define "kyverno.config.metricsConfigMapAnnotations" -}}
  {{- template "kyverno.annotations.merge" (list
    (toYaml .Values.customAnnotations)
    (toYaml .Values.metricsConfig.annotations)
  ) -}}
{{- end -}}

{{- define "kyverno.config.configMapAnnotations" -}}
  {{- template "kyverno.annotations.merge" (list
    (toYaml .Values.customAnnotations)
    (toYaml .Values.config.annotations)
  ) -}}
{{- end -}}
