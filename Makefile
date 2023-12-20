CONTAINER_REGISTRY = registry.gitlab.kuleuven.be/u0165022/riscv-ci-env
VERSION = v1.0.3

# --------------------------------------------------------------
# Build images
# --------------------------------------------------------------

.PONY: build
build: build-toolchain build-spike build-cva6

.PONY: build-toolchain
build-toolchain:
	docker build --target toolchain -t toolchain:wip .

.PONY: build-spike
build-spike:
	docker build --target spike -t spike:wip .

.PONY: build-cva6
build-cva6:
	docker build --target cva6 -t cva6:wip .

# --------------------------------------------------------------
# Versioned images for release
# --------------------------------------------------------------

.PONY: release
release: push-version push-latest

.PONY: tag-version
tag-version:
	docker tag toolchain:wip $(CONTAINER_REGISTRY)/toolchain:$(VERSION)
	docker tag spike:wip $(CONTAINER_REGISTRY)/spike:$(VERSION)
	docker tag cva6:wip $(CONTAINER_REGISTRY)/cva6:$(VERSION)

.PONY: tag-latest
tag-latest:
	docker tag toolchain:wip $(CONTAINER_REGISTRY)/toolchain:latest
	docker tag spike:wip $(CONTAINER_REGISTRY)/spike:latest
	docker tag cva6:wip $(CONTAINER_REGISTRY)/cva6:latest

.PONY: push-version
push-version: tag-version
	docker push $(CONTAINER_REGISTRY)/toolchain:$(VERSION)
	docker push $(CONTAINER_REGISTRY)/spike:$(VERSION)
# docker push $(CONTAINER_REGISTRY)/cva6:$(VERSION)

.PONY: push-latest
push-latest: tag-latest
	docker push $(CONTAINER_REGISTRY)/toolchain:latest
	docker push $(CONTAINER_REGISTRY)/spike:latest
# docker push $(CONTAINER_REGISTRY)/cva6:$(VERSION)