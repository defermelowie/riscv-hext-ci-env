SPIKE_REPO=https://github.com/riscv-software-src/riscv-isa-sim.git;

# Install dependencies
apt-get install build-essential device-tree-compiler -y

# Clone repo
git clone $SPIKE_REPO spike

# Build executable
mkdir -p spike/build && cd spike/build
../configure
make

# Copy executable to $BIN
cp ./spike $BIN/