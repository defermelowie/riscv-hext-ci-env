CONTAINER_REGISTRY = registry.gitlab.kuleuven.be/u0165022/riscv-ci-env

.PONY: all
all: toolchain spike

.PONY: toolchain
toolchain:
	docker build --target toolchain -t $(CONTAINER_REGISTRY):toolchain .

.PONY: spike
spike:
	docker build --target spike -t $(CONTAINER_REGISTRY):spike .

.PONY: release
release: toolchain spike
	docker push $(CONTAINER_REGISTRY):toolchain
	docker push $(CONTAINER_REGISTRY):spike