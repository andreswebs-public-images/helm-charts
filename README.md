# helm-charts

A collection of public Helm charts, published as OCI artifacts to Amazon ECR
Public.

## Charts

| Chart | Description |
|-------|-------------|
| [app](charts/app/README.md) | Generic application chart: Deployment, Service, optional Ingress, HPA, PDB, NetworkPolicy, ConfigMap and RBAC |

## Requirements

Helm 4 is the supported client. The charts are rendered and tested with Helm 4
in CI.

## Installing

```sh
helm install "${RELEASE_NAME}" "oci://public.ecr.aws/${ECR_PUBLIC_ALIAS}/charts/${CHART_NAME}" \
  --version "${CHART_VERSION}" \
  --values "${VALUES_FILE}"
```

Each chart's README lists its values and any upgrade notes.

## Verifying signatures

Published charts are signed with cosign using keyless signing from GitHub
Actions. Verify a chart before installing it:

```sh
cosign verify \
  --certificate-identity-regexp "^https://github.com/andreswebs-public-images/helm-charts/" \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  "public.ecr.aws/${ECR_PUBLIC_ALIAS}/charts/${CHART_NAME}:${CHART_VERSION}"
```

## Versioning and releases

Charts follow semantic versioning. Under `0.x`, a minor version bump may
contain breaking changes; they are listed in the chart README under
"Upgrading".

Every change to a chart must bump its `version` in `Chart.yaml`. The pull
request workflow fails otherwise. On merge to `main`, the publish workflow
pushes each chart whose version is not yet in the registry, signs it, and
creates a GitHub release tagged `<chart>-<version>` with the packaged chart
attached. Versions already in the registry are skipped, and the registry
repositories are expected to use immutable tags.

## Development

Install [pre-commit](https://pre-commit.com/) and Docker. The hooks lint all
charts with chart-testing, run the helm-unittest suites and regenerate the
chart READMEs with helm-docs:

```sh
pre-commit run --all-files
```

Rendering scenarios for CI live in `charts/<chart>/ci/*-values.yaml`.
chart-testing lints the chart once per file, and the pull request workflow
renders each one, validates it with kubeconform, and posts a diff against the
target branch to the job summary.

Unit tests live in `charts/<chart>/tests/`.

## Authors

**Andre Silva** [andreswebs](https://github.com/andreswebs)

## License

This project is licensed under the [Unlicense](UNLICENSE).
