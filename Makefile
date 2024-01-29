REGISTRY = registry.gitlab.kuleuven.be/u0165022/riscv-ci-env
VERSION ?= wip

# --------------------------------------------------------------
# Build & tag images
# --------------------------------------------------------------

.PONY: build build-%
build: build-toolchain build-spike build-qemu build-cva6

build-%:
	docker build --target $* -t $*:wip .

# --------------------------------------------------------------
# Versioned images for release
# --------------------------------------------------------------

.PONY: release push-% tag-%
release: push-toolchain push-spike push-qemu

tag-%: build-%
	docker tag $*:wip $(REGISTRY)/$*:$(VERSION)
	docker tag $*:wip $(REGISTRY)/$*:latest

push-%: tag-%
	docker push $(REGISTRY)/$*:$(VERSION)
	docker push $(REGISTRY)/$*:latest
	