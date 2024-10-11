#!/usr/bin/env bash
docker run \
    --rm \
    --interactive \
    --volume "$(pwd):/apps" \
    helmunittest/helm-unittest ${@}
