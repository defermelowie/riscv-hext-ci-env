REGISTRY = registry.gitlab.kuleuven.be/u0165022/riscv-ci-env
VERSION ?= wip

IMAGES = toolchain 
IMAGES += spike 
IMAGES += qemu
# IMAGES += cva6

# --------------------------------------------------------------
# Build & tag images
# --------------------------------------------------------------

.PONY: build build-%
build: $(IMAGES:%=build-%)

build-%:
	docker build --target $* -t $*:wip .

# --------------------------------------------------------------
# Versioned images for release
# --------------------------------------------------------------

.PONY: release push-% tag-%
release: $(IMAGES:%=push-%)

tag-%: build-%
	docker tag $*:wip $(REGISTRY)/$*:$(VERSION)
	docker tag $*:wip $(REGISTRY)/$*:latest

push-%: tag-%
	docker push $(REGISTRY)/$*:$(VERSION)
	docker push $(REGISTRY)/$*:latest
	