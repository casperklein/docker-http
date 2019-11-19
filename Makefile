# all targets are phony (no files to check)
.PHONY: default build clean push

USER := $(shell grep -P 'ENV\s+USER=".+?"' Dockerfile | cut -d'"' -f2)
NAME := $(shell grep -P 'ENV\s+NAME=".+?"' Dockerfile | cut -d'"' -f2)
VERSION := $(shell grep -P 'ENV\s+VERSION=".+?"' Dockerfile | cut -d'"' -f2)

default: build

build:
	./build.sh

clean:
	docker rmi $(USER)/$(NAME):$(VERSION)

push:
	echo "Pushing image to docker hub.."
	USER=$$(grep -P 'ENV\s+USER=".+?"' Dockerfile | cut -d'"' -f2) && \
	NAME=$$(grep -P 'ENV\s+NAME=".+?"' Dockerfile | cut -d'"' -f2) && \
	VERSION=$$(grep -P 'ENV\s+VERSION=".+?"' Dockerfile | cut -d'"' -f2) && \
	docker push $$USER/$$NAME:$$VERSION
