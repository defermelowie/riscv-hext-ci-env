# Start with ubuntu base image
FROM ubuntu:latest

# Set `/ci` as top-level working directory
WORKDIR /ci

# Copy emulator resources into container
COPY spike /ci/res/spike
COPY cva6 /ci/res/cva6

# # Build spike emulator
# RUN apt-get update && apt-get install gcc make build-essential device-tree-compiler -y
# RUN mkdir -p ./res/spike/build \
#     && cd ./res/spike/build \
#     && ../configure \
#     && make
# RUN cd /ci \
#     && mkdir -p bin \
#     && cp ./res/spike/build/spike ./bin/spike

# Get verilator 4.014 (requirement of cva6)
RUN mkdir -p ./res/verilator
RUN cd ./res/verilator && wget https://www.veripool.org/ftp/verilator-4.014.tgz

# TODO: build cva6 emulator
RUN apt-get update && apt-get install git gcc make gcc-riscv64-unknown-elf -y
ENV RISCV=/usr/bin
RUN cd ./res/cva6/ \
    && verilator --version \
    && make verilate

# Put "emulators" into path
ENV PATH=$PATH:/ci/bin