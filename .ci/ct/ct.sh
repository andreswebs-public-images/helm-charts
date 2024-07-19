#!/usr/bin/env bash

CT_VER="${CT_VER:-v3.7.1}"

docker run --rm -t --workdir=/data --volume "$(pwd)":/data quay.io/helmpack/chart-testing:"${CT_VER}" ct lint --config .ci/ct/ct.yaml --all
