# --------------------------------------------------------------
# Base image with common tools
# --------------------------------------------------------------

FROM ubuntu:mantic as base

# Set environment variables
ENV BIN=/ci/bin
ENV PATH=$PATH:$BIN

# Setup working directory
WORKDIR /ci
RUN mkdir -p $BIN/

# Update package list and install common tools
RUN apt-get update && apt-get install git make gcc build-essential -y

# --------------------------------------------------------------
# Image with RISC-V gnu and llvm toolchains
# --------------------------------------------------------------

FROM base as toolchain
RUN apt-get install gcc-riscv64-unknown-elf -y
RUN apt-get install clang -y
# Install clang-17 from nightly sources
# RUN apt-get install wget -y
# RUN echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main\ndeb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-17 main" >> /etc/apt/sources.list
# RUN wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
# RUN apt-get update && apt-get install clang-17 -y
# RUN echo "alias clang=clang-17" >> ~/.profile

# --------------------------------------------------------------
# Image with spike emulator
# --------------------------------------------------------------

FROM toolchain as spike-builder
ENV SPIKE_REPO=https://github.com/riscv-software-src/riscv-isa-sim.git

RUN apt-get install device-tree-compiler -y
RUN git clone $SPIKE_REPO spike
RUN mkdir spike/build && cd spike/build && ../configure
RUN make -C spike/build

# --------------------------------------------------------------

FROM base as spike
RUN apt-get install device-tree-compiler -y
COPY --from=spike-builder /ci/spike/build/spike $BIN/
COPY --from=spike-builder /ci/spike/build/spike-dasm $BIN/
COPY --from=spike-builder /ci/spike/build/spike-log-parser $BIN/
COPY --from=spike-builder /ci/spike/build/xspike $BIN/
COPY --from=spike-builder /ci/spike/build/termios-xspike $BIN/
COPY --from=spike-builder /ci/spike/build/elf2hex $BIN/

# --------------------------------------------------------------
# TODO: Image with cva6 model
# --------------------------------------------------------------

FROM toolchain as cva6-builder
ENV CVA6_REPO=https://github.com/minho-pulp/cva6.git
ENV CVA6_REPO_DIR=/ci/cva6
ENV RISCV=/usr/bin

RUN apt-get install verilator -y
RUN git clone $CVA6_REPO $CVA6_REPO_DIR
WORKDIR $CVA6_REPO_DIR
RUN git submodule update --init --recursive
RUN echo "TODO: build cva model"
RUN apt-get install sudo curl wget -y

FROM base as cva6
RUN echo "TODO: install cva6 runtime deps"
RUN echo "TODO: copy required cva6 artifacts"

