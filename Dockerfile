# Start with ubuntu base image
FROM ubuntu:latest

# `/ci` is the top-level working directory
WORKDIR /ci

# Copy emulator resources into container
COPY spike /ci/res/spike
COPY cva6 /ci/res/cva6

# Build spike emulator
RUN apt-get update \
    && apt-get install gcc make git build-essential device-tree-compiler -y
RUN mkdir -p ./res/spike/build \
    && cd ./res/spike/build \
    && ../configure \
    && make
RUN cd /ci \
    && mkdir -p bin \
    && cp ./res/spike/build/spike ./bin/spike