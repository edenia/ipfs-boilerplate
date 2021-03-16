-include .env

VERSION ?= $(shell git ls-files -s k8s | git hash-object --stdin)

DOCKER_REGISTRY=

MAKE_ENV += DOCKER_REGISTRY VERSION IMAGE_NAME

SHELL_EXPORT := $(foreach v,$(MAKE_ENV),$(v)='$($(v))')
K8S_BUILD_DIR ?= ./build_k8s
K8S_FILES := $(shell find ./k8s -name '*.yml' | sed 's:./k8s/::g')

ifneq ("$(wildcard .env)", "")
	export $(shell sed 's/=.*//' .env)
endif
