#!/usr/bin/env bash
# Run helm-unittest in a container. Arguments are chart directories or
# helm-unittest flags.
set -euo pipefail

HELM_UNITTEST_VER="${HELM_UNITTEST_VER:-4.3.0-1.2.1}"

docker run \
    --rm \
    --interactive \
    --volume "$(pwd):/apps" \
    "helmunittest/helm-unittest:${HELM_UNITTEST_VER}" \
    "$@"
