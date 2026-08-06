GIT_COMMIT_SHA ?= $(shell git rev-parse HEAD)

BASE_IMAGE_NAME = derekpedersen/build-jenkins-base
BASE_IMAGE_LATEST = $(BASE_IMAGE_NAME):latest
BASE_IMAGE_SHA = $(BASE_IMAGE_NAME):$(GIT_COMMIT_SHA)
AGENT_DIRS = dotnetcore golang node

build:
	docker build ./ \
		-t $(BASE_IMAGE_LATEST) \
		-t $(BASE_IMAGE_SHA) \
		-t build-jenkins-base:latest

publish-docker: build
	docker push $(BASE_IMAGE_LATEST)
	docker push $(BASE_IMAGE_SHA)

build-agents: build
	@for dir in $(AGENT_DIRS); do \
		$(MAKE) -C $$dir build GIT_COMMIT_SHA=$(GIT_COMMIT_SHA); \
	done

publish-agents: publish-docker
	@for dir in $(AGENT_DIRS); do \
		$(MAKE) -C $$dir publish-docker GIT_COMMIT_SHA=$(GIT_COMMIT_SHA); \
	done

build-publish-all: publish-agents
	@echo "Built and published base and agent images."