VERSION ?= latest
MODE ?= direct
ARCH ?= x86_64
TAGS ?= latest
IMAGE ?= 525999333867.dkr.ecr.us-west-1.amazonaws.com/lambda/bun

.PHONY = build push help vars print-var

default: help

## Clean the project, removing all build artifacts
clean:
	@while IFS= read -r pattern; do \
	  if [[ ! $$pattern =~ ^#.*$$ && -n $$pattern ]]; then \
	    find . -path "$$pattern" -exec rm -rf {} +; \
	  fi; \
	done < .cleanrc

## Build the Docker image
build:
	docker build . \
		--provenance "false" \
		--platform "linux/$(patsubst x86_64,amd64,$(ARCH))" \
		--build-arg BUN_VERSION="$(VERSION)" \
		--build-arg LAMBDA_RUNTIME_MODE="$(MODE)" \
		$(TAGS:%=--tag "$(IMAGE):%")

## Push the Docker image to the registry
push: build
	aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin ${IMAGE}

	$(foreach tag,$(TAGS), \
		docker push $(IMAGE):$(tag) \
	$(\n))

## Publish a specific image to the registry
publish: LATEST := false
publish: TAGS := $(shell scripts/publish.sh --version $(VERSION) --latest $(LATEST) --arch $(ARCH))
publish: push

## Publish a specific version to the registry
publish/%:
	$(MAKE) publish VERSION=$* ARCH=x86_64
	$(MAKE) publish VERSION=$* ARCH=arm64

## This help screen
help:
	@printf "Available targets:\n\n"
	@awk '/^[a-zA-Z\-\_0-9%:\\]+/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = $$1; \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			gsub("\\\\", "", helpCommand); \
			gsub(":+$$", "", helpCommand); \
			printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u
	@printf "\n"

## Show the variables used in the Makefile and their values
vars:
	@printf "Variable values:\n\n"
	@awk 'BEGIN { FS = "[:?]?="; } /^[A-Za-z0-9_]+[[:space:]]*[:?]?=/ { \
		if ($$0 ~ /\?=/) operator = "?="; \
		else if ($$0 ~ /:=/) operator = ":="; \
		else operator = "="; \
		print $$1, operator; \
	}' $(MAKEFILE_LIST) | \
	while read var op; do \
		value=$$(make --no-print-directory -f $(MAKEFILE_LIST) print-var VAR=$$var); \
		printf "  \x1b[32;01m%-35s\x1b[0m%2s \x1b[34;01m%s\x1b[0m\n" "$$var" "$$op" "$$value"; \
	done
	@printf "\n"

print-var:
	@echo $($(VAR))

define \n


endef
