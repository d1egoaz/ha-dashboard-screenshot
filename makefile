# Makefile for Home Assistant Dashboard Screenshot Tool

# Use bash as the default shell
SHELL := /bin/bash

# Docker image details
IMAGE_NAME := d1egoaz/ha_dashboard_screenshot
TAG := latest

# Platforms (support multiple architectures)
PLATFORMS := linux/amd64,linux/arm64

# Build the Docker image with multi-arch support
build:
	docker buildx create --use --name multiarch-builder --driver docker-container
	docker buildx inspect multiarch-builder --bootstrap
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE_NAME):$(TAG) \
		--push \
		.

# Build for local testing (single platform)
build-local:
	docker build -t  $(IMAGE_NAME):$(TAG) . --platform linux/amd64

# Run the container
run:
	docker run --rm \
		-v "$(PWD)/options.json:/data/options.json:ro" \
		-v "$(PWD)/config:/config" \
		$(IMAGE_NAME):$(TAG)

# Clean up docker resources
clean:
	docker rmi $(IMAGE_NAME):$(TAG) 2>/dev/null || true
	docker buildx rm multiarch-builder 2>/dev/null || true

# Help target
help:
	@echo "Available targets:"
	@echo "  build        - Build multi-arch Docker image and push to registry"
	@echo "  build-local  - Build Docker image for local testing"
	@echo "  run          - Run the Docker container"
	@echo "  clean        - Remove the built image and builder"
	@echo "  help         - Show this help message"

.PHONY: build build-local run clean help
