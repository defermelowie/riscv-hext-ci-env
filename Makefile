CONTAINER_REGISTRY = registry.gitlab.kuleuven.be/u0165022/riscv-ci-env
VERSION = v1.0.1

# --------------------------------------------------------------
# Build images
# --------------------------------------------------------------

.PONY: build
build: build-toolchain build-spike

.PONY: build-toolchain
build-toolchain:
	docker build --target toolchain -t toolchain:wip .

.PONY: build-spike
build-spike:
	docker build --target spike -t spike:wip .

# --------------------------------------------------------------
# Versioned images for release
# --------------------------------------------------------------

.PONY: release
release: tag-version push-version

.PONY: tag-version
tag-version:
	docker tag toolchain:wip $(CONTAINER_REGISTRY)/toolchain:$(VERSION)
	docker tag spike:wip $(CONTAINER_REGISTRY)/spike:$(VERSION)

.PONY: push-version
push-version:
	docker push $(CONTAINER_REGISTRY)/toolchain:$(VERSION)
	docker push $(CONTAINER_REGISTRY)/spike:$(VERSION)