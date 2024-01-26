CONTAINER_REGISTRY = registry.gitlab.kuleuven.be/u0165022/riscv-ci-env
VERSION ?= wip

# --------------------------------------------------------------
# Build & tag images
# --------------------------------------------------------------

.PONY: build
build: build-toolchain build-spike build-cva6

.PONY: build-%
build-%:
	docker build --target $* -t $*:wip .

# --------------------------------------------------------------
# Versioned images for release
# --------------------------------------------------------------

.PONY: release push-% tag-%

release: push-toolchain push-spike

tag-%: build-%
	docker tag $*:wip $(CONTAINER_REGISTRY)/$*:$(VERSION)
	docker tag $*:wip $(CONTAINER_REGISTRY)/$*:latest

push-%: tag-%
	docker push $(CONTAINER_REGISTRY)/$*:$(VERSION)
	docker push $(CONTAINER_REGISTRY)/$*:latest