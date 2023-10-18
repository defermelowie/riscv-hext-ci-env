#!/usr/bin/env bash

# Define variables
CONTAINER_REGISTRY=registry.gitlab.kuleuven.be;
CONTAINER_TEST_IMAGE=$CONTAINER_REGISTRY/u0165022/riscv-ci-env:test;
CONTAINER_RELEASE_IMAGE=$CONTAINER_REGISTRY/u0165022/riscv-ci-env:cva6;


# Build container
docker build --pull -t $CONTAINER_TEST_IMAGE .

# Test emulators
docker run $CONTAINER_TEST_IMAGE spike -h || exit -1

# Release to registry
docker tag $CONTAINER_TEST_IMAGE $CONTAINER_RELEASE_IMAGE
docker push $CONTAINER_RELEASE_IMAGE

# Successful exit
exit 0