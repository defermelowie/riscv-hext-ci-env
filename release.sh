#!/usr/bin/env bash

# Define variables
CONTAINER_REGISTRY=registry.gitlab.kuleuven.be;
CONTAINER_WIP_IMG=$CONTAINER_REGISTRY/u0165022/riscv-ci-env:wip;
CONTAINER_REL_IMG=$CONTAINER_REGISTRY/u0165022/riscv-ci-env:latest;


# Build container
docker build --pull -t $CONTAINER_WIP_IMG .

# Test emulators
docker run $CONTAINER_WIP_IMG spike -h || exit -1

# Release to registry
docker tag $CONTAINER_WIP_IMG $CONTAINER_REL_IMG
docker push $CONTAINER_REL_IMG

# Successful exit
exit 0