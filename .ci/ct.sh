#!/usr/bin/env bash

CT_VER="${CT_VER:-v3.11.0}"

docker run \
    --rm \
    --tty \
    --workdir="/data" \
    --volume "$(pwd):/data" \
    "quay.io/helmpack/chart-testing:${CT_VER}" ct lint --config .ci/ct/ct.yaml --all
