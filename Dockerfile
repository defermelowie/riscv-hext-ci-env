# --------------------------------------------------------------
# Base image with common tools
# --------------------------------------------------------------

FROM ubuntu:mantic as base

# Add RISC-V tools to path
ENV RISCV=/opt/riscv
ENV PATH=$PATH:$RISCV/bin
RUN mkdir -p $RISCV/bin

# Update package list and install common tools for all images
RUN apt-get update && apt-get install git make -y

# --------------------------------------------------------------
# Image with RISC-V GNU and LLVM toolchains
# --------------------------------------------------------------

FROM base as toolchain-builder

RUN apt-get update && apt-get install autoconf automake autotools-dev curl python3 python3-pip libmpc-dev \
                    libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils \
                    bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev gcc -y
WORKDIR /toolchain
COPY riscv-gnu-toolchain riscv-gnu-toolchain
COPY .git/modules/riscv-gnu-toolchain .git/modules/riscv-gnu-toolchain
WORKDIR riscv-gnu-toolchain
RUN ./configure --prefix=$RISCV --enable-multilib --with-cmodel=medany 
RUN make linux

# --------------------------------------------------------------

FROM base as toolchain
RUN apt-get update
# Install LLVM based toolchain
RUN apt-get install clang -y
# Install GNU bare metal toolchain
RUN apt-get install gcc-riscv64-unknown-elf -y
# Copy GNU linux toolchain
COPY --from=toolchain-builder $RISCV $RISCV


# --------------------------------------------------------------
# Image with spike emulator
# --------------------------------------------------------------

FROM toolchain as spike-builder

WORKDIR /ci
RUN apt-get update && apt-get install gcc build-essential device-tree-compiler -y
COPY riscv-isa-sim spike
RUN mkdir spike/build && cd spike/build && ../configure
RUN make -C spike/build

# --------------------------------------------------------------

FROM base as spike
RUN apt-get update && apt-get install device-tree-compiler -y
COPY --from=spike-builder /ci/spike/build/spike $RISCV/bin
COPY --from=spike-builder /ci/spike/build/spike-dasm $RISCV/bin
COPY --from=spike-builder /ci/spike/build/spike-log-parser $RISCV/bin
COPY --from=spike-builder /ci/spike/build/xspike $RISCV/bin
COPY --from=spike-builder /ci/spike/build/termios-xspike $RISCV/bin
COPY --from=spike-builder /ci/spike/build/elf2hex $RISCV/bin

# --------------------------------------------------------------
# Image with RISC-V qemu instance
# --------------------------------------------------------------

FROM base as qemu
RUN apt-get update && apt-get install qemu-system-riscv64 -y
