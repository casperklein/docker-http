# all targets are phony (no files to check)
.PHONY: default build clean push

SHELL = /bin/bash

IMAGE := $(shell jq -er '.image' < config.json)
TAG := $(shell jq -er '"\(.image):\(.version)"' < config.json)

default: build

build:
	@./build.sh

clean:
	@echo "Removing Docker images.."
	docker rmi "$(TAG)"; \
	docker rmi "$(IMAGE):latest"

push:
	@echo "Pushing image to Docker Hub.."
	docker push "$(TAG)"
	docker push "$(IMAGE):latest"
