# --------------------------------------------------------------
# Base image with scripts & common tools
# --------------------------------------------------------------

FROM ubuntu:latest as base

# Set environment variables
ENV SCRIPT=/ci/scripts
ENV BIN=/ci/bin
ENV PATH=$PATH:$BIN

# Setup working directory
WORKDIR /ci
COPY scripts/* $SCRIPT/
RUN mkdir -p $BIN/

# Update package list and install common tools
RUN apt-get update && apt-get install git make build-essential gcc -y

# --------------------------------------------------------------
# Image with riscv64-unknown-elf-* toolchain
# --------------------------------------------------------------

FROM base as toolchain
RUN apt-get install gcc-riscv64-unknown-elf -y
RUN apt-get install clang -y

# --------------------------------------------------------------
# Image with spike emulator
# --------------------------------------------------------------

FROM toolchain as spike
RUN $SCRIPT/install-spike.sh

# --------------------------------------------------------------
# TODO: Image with cva6 model
# --------------------------------------------------------------

# FROM toolchain as cva6
# RUN $SCRIPT/install-cva6.sh

