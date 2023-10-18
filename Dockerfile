# Start with ubuntu base image
FROM ubuntu:latest

# Set environment variables
ENV SCRIPT=/ci/scripts
ENV BIN=/ci/bin
ENV PATH=$PATH:$BIN

# Setup working directory
WORKDIR /ci
COPY scripts/* $SCRIPT/
RUN mkdir -p $BIN/

# Update package list and install common tools
RUN apt-get update && apt-get install git make gcc -y
RUN apt-get install gcc-riscv64-unknown-elf -y
RUN apt-get install clang -y

# Build emulators/models
RUN $SCRIPT/install-spike.sh
RUN $SCRIPT/install-cva6.sh

