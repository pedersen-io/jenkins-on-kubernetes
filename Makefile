GIT_COMMIT_SHA ?= $(shell git rev-parse HEAD)
BASE_IMAGE_NAME = derekpedersen/build-jenkins-base
BASE_IMAGE_LATEST = $(BASE_IMAGE_NAME):latest
BASE_IMAGE_SHA = $(BASE_IMAGE_NAME):$(GIT_COMMIT_SHA)
AGENT_DIRS = dotnetcore golang node python rust c java php ruby k8s-tooling playwright
HELM_RELEASE ?= jenkins
HELM_NAMESPACE ?= jenkins
HELM_CHART ?= jenkins/jenkins
HELM_VALUES ?= values.yaml
HELM_REPO_NAME ?= jenkins
HELM_REPO_URL ?= https://charts.jenkins.io

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
		$(MAKE) -C $$dir build GIT_COMMIT_SHA=$(GIT_COMMIT_SHA) || exit 1; \
	done

publish-agents: publish-docker build-agents
	@for dir in $(AGENT_DIRS); do \
		$(MAKE) -C $$dir publish-docker GIT_COMMIT_SHA=$(GIT_COMMIT_SHA) || exit 1; \
	done

build-publish-all: publish-agents
	@echo "Built and published base and agent images."


helm-repo-init:
	helm repo add $(HELM_REPO_NAME) $(HELM_REPO_URL) || true
	helm repo update

helm-upgrade: helm-repo-init
	helm upgrade --install $(HELM_RELEASE) $(HELM_CHART) -n $(HELM_NAMESPACE) -f $(HELM_VALUES)

helm-upgrade-init: helm-upgrade