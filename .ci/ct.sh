#!/usr/bin/env bash
# Run chart-testing lint in a container. Extra arguments are passed to ct lint;
# with none, all charts are linted.
set -euo pipefail

CT_VER="${CT_VER:-v3.14.0}"

if [ "$#" -eq 0 ]; then
    set -- --all
fi

docker run \
    --rm \
    --tty \
    --workdir="/data" \
    --volume "$(pwd):/data" \
    "quay.io/helmpack/chart-testing:${CT_VER}" \
    ct lint --config .ci/ct/ct.yaml "$@"
