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
# Image with RISC-V gnu and llvm toolchains
# --------------------------------------------------------------

FROM base as toolchain
# Install both, GNU & LLVM based toolchains
RUN apt-get install gcc-riscv64-unknown-elf -y
RUN apt-get install gcc-riscv64-linux-gnu -y
RUN apt-get install clang -y

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
