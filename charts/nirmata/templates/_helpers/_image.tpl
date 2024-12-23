{{/* vim: set filetype=mustache: */}}

{{- define "kyverno.image" -}}
{{- $tag := default .defaultTag .image.tag -}}
{{- if not (typeIs "string" $tag) -}}
  {{ fail "Image tags must be strings." }}
{{- end -}}
{{- $imageRegistry := default .image.registry .globalRegistry -}}
{{- $fipsEnabled := .fipsEnabled -}}
{{- if $imageRegistry -}}
  {{- if $fipsEnabled -}}
    {{- print $imageRegistry "/" (required "An image repository is required" .image.repository) "-fips:v1.12.6-n4k.nirmata.3-rc2"  -}}
  {{- else -}}
    {{- print $imageRegistry "/" (required "An image repository is required" .image.repository) ":" $tag -}}
  {{- end -}}
{{- else -}}
  {{- print (required "An image repository is required" .image.repository) ":" $tag -}}
{{- end -}}
{{- end -}}
