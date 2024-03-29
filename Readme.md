# RISC-V CI Environment

Several docker images for use in CI of bare metal RISC-V programs:

- `toolchain`: Contains the gcc-riscv64-unknown-elf as well as llvm toolchains for RISC-V
- `spike`: Contains the spike isa simulator
- `qemu`: Contains qemu-system-riscv64

## ToDo

- [x] Bump clang version in order to support 'h' extension in -march
    - _Bumped `ubuntu:latest` to `ubuntu:mantic` which ships `clang-16`_
- [x] Build [spike](https://github.com/riscv-software-src/riscv-isa-sim)
- [ ] Build emulator from [rocket-chip](https://github.com/chipsalliance/rocket-chip)
- [ ] Build hypervisor capable emulator from [minho-pulp/cva6](https://github.com/minho-pulp/cva6) fork of [openhwgroup/cva6](https://github.com/openhwgroup/cva6)
