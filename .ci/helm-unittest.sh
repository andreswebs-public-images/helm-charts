#!/usr/bin/env bash
docker run \
    --rm \
    --tty \
    --interactive \
    --volume "$(pwd):/apps" \
    helmunittest/helm-unittest charts/app
