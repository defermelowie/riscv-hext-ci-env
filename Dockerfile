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
RUN apt-get update
RUN apt-get install git make gcc build-essential -y

# --------------------------------------------------------------
# Image with RISC-V GNU and LLVM toolchains
# --------------------------------------------------------------

FROM base as toolchain-builder

RUN apt-get install autoconf automake autotools-dev curl python3 python3-pip libmpc-dev libmpfr-dev \
                    libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc  \
                    zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev -y
COPY riscv-gnu-toolchain riscv-gnu-toolchain
COPY .git/modules/riscv-gnu-toolchain .git/modules/riscv-gnu-toolchain
WORKDIR riscv-gnu-toolchain
RUN ./configure --prefix=/opt/riscv --enable-multilib --with-cmodel=medany 
RUN make
RUN make linux
RUN make musl

# --------------------------------------------------------------

FROM base as toolchain
# Install LLVM based toolchain
RUN apt-get install clang -y
# TODO: Copy gnu toolchain
# RUN apt-get install gcc-riscv64-unknown-elf -y
COPY --from=toolchain-builder /opt/riscv/bin/* $BIN/


# --------------------------------------------------------------
# Image with spike emulator
# --------------------------------------------------------------

FROM toolchain as spike-builder

RUN apt-get install device-tree-compiler -y
COPY riscv-isa-sim spike
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
# Image with RISC-V qemu instance
# --------------------------------------------------------------

FROM base as qemu
RUN apt-get install qemu-system-riscv64 -y
