# Start with ubuntu base image
FROM ubuntu:latest

# Set `/ci` as top-level working directory
WORKDIR /ci

# Copy resources into container
COPY spike /ci/res/spike
COPY verilator /ci/res/verilator
COPY cva6 /ci/res/cva6

# Build spike emulator
RUN apt-get update
RUN apt-get install gcc make build-essential device-tree-compiler -y
RUN mkdir -p ./res/spike/build \
    && cd ./res/spike/build \
    && ../configure
RUN cd ./res/spike/build && make
RUN mkdir -p bin \
    && cp ./res/spike/build/spike ./bin/spike

# # Build verilator (requirement of cva6)
# RUN apt-get update && apt-get install make autoconf gcc g++ flex bison ccache -y
# RUN unset VERILATOR_ROOT \
#     && cd ./res/verilator \
#     && autoconf \
#     && ./configure  
# RUN cd ./res/verilator \
#     && make \
#     && make install

# # TODO: build cva6 emulator
# RUN apt-get update && apt-get install gcc make gcc-riscv64-unknown-elf -y
# ENV RISCV=/usr/bin
# RUN cd ./res/cva6/ \
#     && verilator --version \
#     && make verilate

# Put "emulators" into path
ENV PATH=$PATH:/ci/bin