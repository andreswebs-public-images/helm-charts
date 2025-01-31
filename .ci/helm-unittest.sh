#!/usr/bin/env bash
# shellcheck disable=SC2068
docker run \
    --rm \
    --interactive \
    --volume "$(pwd):/apps" \
    helmunittest/helm-unittest ${@}
