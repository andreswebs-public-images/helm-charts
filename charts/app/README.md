# app

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Generic application chart

## Usage

The chart is published as an OCI artifact. Set the image and install:

```sh
helm install "${RELEASE_NAME}" "oci://public.ecr.aws/${ECR_PUBLIC_ALIAS}/charts/app" \
  --version "0.1.0" \
  --set image.repository="${IMAGE_REPOSITORY}" \
  --set image.tag="${IMAGE_TAG}"
```

`image.repository` and one of `image.tag` or `image.digest` are required.

## Defaults worth knowing

- The pod and container security contexts satisfy the restricted Pod Security
  Standard. Images that run as root must set
  `deployment.podSecurityContext.runAsNonRoot: false`, or set
  `deployment.podSecurityContext.runAsUser` when the image has no numeric `USER`.
- The ServiceAccount token is not mounted unless
  `serviceAccount.automountServiceAccountToken` is `true`.
- A PodDisruptionBudget is only rendered when `deployment.replicas` is greater
  than one or autoscaling is enabled. `pdb.minAvailable` and
  `pdb.maxUnavailable` are mutually exclusive; set the unused one to `null`.
- When `autoscaling.enabled` is `true`, `deployment.replicas` is not rendered.
- Entries under `config` become a ConfigMap named after the release. Scalars are
  converted to strings. A checksum annotation on the pod template triggers a
  rollout when the ConfigMap changes.
- Values documented as "rendered as a template" accept Helm template
  expressions, for example `'{{ include "app.fullname" . }}'`.

## Upgrading

### To 0.1.0

This release changes the selector labels and renames several values. A release
installed from 0.0.x cannot be upgraded in place because Deployment selectors
are immutable: uninstall the 0.0.x release and install 0.1.0.

- `app.kubernetes.io/name` is now the chart (or `nameOverride`) name instead of
  the full release name. `app.kubernetes.io/part-of` is no longer set.
- `*.enable` keys are renamed to `*.enabled` (`service`, `pdb`, `autoscaling`,
  `networkPolicy`, `ingress`).
- `deployment.securityContext` now configures the container. The pod-level
  context moved to `deployment.podSecurityContext`. Both default to restricted
  settings.
- `rbac.create` defaults to `false` and requires `rbac.rules` when enabled.
- `image.tag` or `image.digest` is required; there is no implicit `latest`.
- `autoscaling.metrics`, `networkPolicy.ingress` and `networkPolicy.egress` are
  lists.
- The default pod anti-affinity is preferred rather than required.
- `ingress.httpHosts[].paths[].pathType` defaults to `Prefix`.
- Unknown values keys are rejected by the schema.

## Requirements

Kubernetes: `>=1.29.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscaling.annotations | object | `{}` | Extra annotations for the HorizontalPodAutoscaler. Values are rendered as templates. |
| autoscaling.behavior | object | `{}` | HPA scaling behavior. |
| autoscaling.enabled | bool | `false` | Create a HorizontalPodAutoscaler. When enabled, `deployment.replicas` is not rendered. |
| autoscaling.labels | object | `{}` | Extra labels for the HorizontalPodAutoscaler. Values are rendered as templates. |
| autoscaling.maxReplicas | int | `3` | Maximum replicas. |
| autoscaling.metrics | list | `[]` | HPA metrics. |
| autoscaling.minReplicas | int | `1` | Minimum replicas. |
| config | object | `{}` | ConfigMap data, keyed by file or variable name. Scalar values are converted to strings. Changes trigger a rollout. |
| deployment.additionalContainers | list | `[]` | Additional containers appended to the pod. Rendered as a template. |
| deployment.affinity | object | `{"podAntiAffinity":{"preferredDuringSchedulingIgnoredDuringExecution":[{"podAffinityTerm":{"labelSelector":{"matchLabels":{"app.kubernetes.io/instance":"{{ .Release.Name }}","app.kubernetes.io/name":"{{ include \"app.name\" . }}"}},"topologyKey":"kubernetes.io/hostname"},"weight":100}]}}` | Affinity rules for the pods. Rendered as a template. Defaults to a soft anti-affinity across nodes. |
| deployment.annotations | object | `{}` | Extra annotations for the Deployment. Values are rendered as templates. |
| deployment.args | list | `[]` | Container arguments. Rendered as a template. |
| deployment.command | list | `[]` | Container entrypoint. Rendered as a template. |
| deployment.dnsConfig | object | `{}` | DNS config for the pods. |
| deployment.dnsPolicy | string | `""` | DNS policy for the pods. |
| deployment.env | list | `[]` | Environment variables. Rendered as a template. |
| deployment.envFrom | list | `[]` | Environment sources (ConfigMaps and Secrets). Rendered as a template. |
| deployment.hostAliases | list | `[]` | Host aliases for the pods. |
| deployment.initContainers | list | `[]` | Init containers. Rendered as a template. |
| deployment.labels | object | `{}` | Extra labels for the Deployment. Values are rendered as templates. |
| deployment.lifecycle | object | `{}` | Container lifecycle hooks. |
| deployment.livenessProbe | object | `{}` | Liveness probe for the main container. |
| deployment.nodeSelector | object | `{}` | Node selector for the pods. Rendered as a template. |
| deployment.podAnnotations | object | `{}` | Extra annotations for the pods. Values are rendered as templates. |
| deployment.podLabels | object | `{}` | Extra labels for the pods. Values are rendered as templates. |
| deployment.podSecurityContext | object | `{"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod-level security context. Defaults satisfy the restricted Pod Security Standard; set `runAsUser` if the image has no numeric USER. |
| deployment.ports | list | `[{"containerPort":8080,"name":"http","protocol":"TCP"}]` | Container ports. |
| deployment.priorityClassName | string | `""` | PriorityClass for the pods. |
| deployment.readinessProbe | object | `{}` | Readiness probe for the main container. |
| deployment.replicas | int | `1` | Number of replicas. Ignored when autoscaling is enabled. |
| deployment.resources | object | `{}` | Resource requests and limits for the main container. |
| deployment.revisionHistoryLimit | string | `nil` | Number of old ReplicaSets to retain. Omitted when null. |
| deployment.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":false}` | Container-level security context for the main container. Defaults satisfy the restricted Pod Security Standard. |
| deployment.startupProbe | object | `{}` | Startup probe for the main container. |
| deployment.strategy | object | `{"rollingUpdate":{"maxSurge":"25%","maxUnavailable":"25%"},"type":"RollingUpdate"}` | Deployment update strategy. |
| deployment.terminationGracePeriodSeconds | int | `30` | Grace period for pod termination, in seconds. |
| deployment.tolerations | list | `[]` | Tolerations for the pods. Rendered as a template. |
| deployment.topologySpreadConstraints | list | `[]` | Topology spread constraints for the pods. Rendered as a template. |
| deployment.volumeMounts | list | `[]` | Volume mounts for the main container. Rendered as a template. |
| deployment.volumes | list | `[]` | Pod volumes. Rendered as a template. |
| fullnameOverride | string | `""` | Override the fully qualified release name used for all resources. |
| image.digest | string | `""` | Image digest (`sha256:...`). Takes precedence over `image.tag`. |
| image.pullPolicy | string | `""` | Image pull policy. Defaults to `IfNotPresent`. |
| image.repository | string | `""` | Container image repository. Required. |
| image.tag | string | `""` | Image tag. Either `image.tag` or `image.digest` is required. |
| imagePullSecrets | list | `[]` | Secrets used to pull the image, as a list of `name:` entries. |
| ingress.annotations | object | `{}` | Extra annotations for the Ingress. Values are rendered as templates. |
| ingress.enabled | bool | `false` | Create an Ingress. |
| ingress.httpHosts | list | `[]` | HTTP rules, each with `host` and `paths` (`path`, `servicePortNumber`, optional `pathType` defaulting to `Prefix`). |
| ingress.ingressClassName | string | `""` | IngressClass name. |
| ingress.labels | object | `{}` | Extra labels for the Ingress. Values are rendered as templates. |
| ingress.tls | list | `[]` | TLS entries, each with `hosts` and an optional `secretName`. |
| nameOverride | string | `""` | Override the chart name used in resource names and labels. |
| namespaceOverride | string | `""` | Deploy resources into this namespace instead of the release namespace. |
| networkPolicy.annotations | object | `{}` | Extra annotations for the NetworkPolicy. Values are rendered as templates. |
| networkPolicy.egress | list | `[]` | Egress rules. |
| networkPolicy.enabled | bool | `false` | Create a NetworkPolicy. At least one of `ingress` or `egress` must be set. |
| networkPolicy.ingress | list | `[]` | Ingress rules. |
| networkPolicy.labels | object | `{}` | Extra labels for the NetworkPolicy. Values are rendered as templates. |
| pdb.annotations | object | `{}` | Extra annotations for the PodDisruptionBudget. Values are rendered as templates. |
| pdb.enabled | bool | `true` | Create a PodDisruptionBudget. Only rendered when replicas > 1 or autoscaling is enabled. |
| pdb.labels | object | `{}` | Extra labels for the PodDisruptionBudget. Values are rendered as templates. |
| pdb.maxUnavailable | string | `nil` | Maximum unavailable pods. Mutually exclusive with `pdb.minAvailable`. |
| pdb.minAvailable | int | `1` | Minimum available pods. Mutually exclusive with `pdb.maxUnavailable`; set to null to use the other. |
| rbac.create | bool | `false` | Create a Role and RoleBinding for the ServiceAccount. Requires `rbac.rules`. |
| rbac.rules | list | `[]` | PolicyRules for the Role. Must be non-empty when `rbac.create` is true. |
| service.annotations | object | `{}` | Extra annotations for the Service. Values are rendered as templates. |
| service.enabled | bool | `true` | Create a Service. |
| service.labels | object | `{}` | Extra labels for the Service. Values are rendered as templates. |
| service.ports | list | `[{"name":"http","port":80,"protocol":"TCP","targetPort":"http"}]` | Service ports. Required when the Service is enabled. |
| service.type | string | `"ClusterIP"` | Service type. |
| serviceAccount.annotations | object | `{}` | Extra annotations for the ServiceAccount. Values are rendered as templates. |
| serviceAccount.automountServiceAccountToken | bool | `false` | Mount the ServiceAccount token into the pod. |
| serviceAccount.create | bool | `true` | Create a ServiceAccount for the workload. |
| serviceAccount.labels | object | `{}` | Extra labels for the ServiceAccount. Values are rendered as templates. |
| serviceAccount.name | string | `""` | Name of the ServiceAccount. Defaults to the fullname when created, or `default` otherwise. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
