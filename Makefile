GIT_COMMIT_SHA ?= $(shell git rev-parse HEAD)
BASE_IMAGE_NAME = derekpedersen/build-jenkins-base
BASE_IMAGE_LATEST = $(BASE_IMAGE_NAME):latest
BASE_IMAGE_SHA = $(BASE_IMAGE_NAME):$(GIT_COMMIT_SHA)
AGENT_DIRS = dotnetcore golang node python rust c java php ruby k8s-tooling playwright
HELM_RELEASE ?= jenkins
HELM_NAMESPACE ?= jenkins
HELM_CHART ?= jenkins/jenkins
HELM_VALUES ?= values.yaml
HELM_CASC_VALUES ?= jenkins-casc.yaml
HELM_REPO_NAME ?= jenkins
HELM_REPO_URL ?= https://charts.jenkins.io
HELM_APP_VERSION_KEY ?= appVersion

.PHONY: build publish-docker build-agents publish-agents build-publish-all scan-image trivy-summary docker-build docker-push docker-build-push helm-repo-init helm-preflight helm-validate helm-render helm-diff helm-deploy helm-upgrade helm-upgrade-init helm-version k8s-deploy-preflight helm-deploy-preflight helm-upgrade-ci

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

scan-image:
	@if [ -z "$(IMAGE_NAME)" ]; then \
		echo "Usage: make scan-image IMAGE_NAME=<image>"; \
		exit 1; \
	fi
	@bash ./.trivy/scan-image.sh "$(IMAGE_NAME)"

trivy-summary:
	@bash ./.trivy/trivy-summary.sh

docker-build:
	@DOCKER_IMAGE_NAME="$(DOCKER_IMAGE_NAME)" \
	DOCKER_TAGS="$(DOCKER_TAGS)" \
	DOCKER_CONTEXT="$(DOCKER_CONTEXT)" \
	DOCKERFILE_PATH="$(DOCKERFILE_PATH)" \
	DOCKER_BUILD_ARGS="$(DOCKER_BUILD_ARGS)" \
	bash ./scripts/docker-build.sh

docker-push:
	@DOCKER_IMAGE_NAME="$(DOCKER_IMAGE_NAME)" \
	DOCKER_TAGS="$(DOCKER_TAGS)" \
	bash ./scripts/docker-push.sh

docker-build-push:
	@$(MAKE) docker-build \
		DOCKER_IMAGE_NAME="$(DOCKER_IMAGE_NAME)" \
		DOCKER_TAGS="$(DOCKER_TAGS)" \
		DOCKER_CONTEXT="$(DOCKER_CONTEXT)" \
		DOCKERFILE_PATH="$(DOCKERFILE_PATH)" \
		DOCKER_BUILD_ARGS="$(DOCKER_BUILD_ARGS)"
	@$(MAKE) docker-push \
		DOCKER_IMAGE_NAME="$(DOCKER_IMAGE_NAME)" \
		DOCKER_TAGS="$(DOCKER_TAGS)"

helm-repo-init:
	helm repo add $(HELM_REPO_NAME) $(HELM_REPO_URL) || true
	helm repo update

helm-validate: helm-repo-init
	@HELM_RELEASE="$(HELM_RELEASE)" \
	HELM_CHART="$(HELM_CHART)" \
	HELM_NAMESPACE="$(HELM_NAMESPACE)" \
	HELM_VALUES="$(HELM_VALUES)" \
	HELM_CASC_VALUES="$(HELM_CASC_VALUES)" \
	HELM_VALUES_FILES="$(HELM_VALUES_FILES)" \
	HELM_SET_ARGS="$(HELM_SET_ARGS)" \
	HELM_EXTRA_ARGS="$(HELM_EXTRA_ARGS)" \
	HELM_VALIDATE_SERVER_DRY_RUN="$(HELM_VALIDATE_SERVER_DRY_RUN)" \
	bash ./scripts/helm-validate.sh

helm-render: helm-repo-init
	@HELM_RELEASE="$(HELM_RELEASE)" \
	HELM_CHART="$(HELM_CHART)" \
	HELM_NAMESPACE="$(HELM_NAMESPACE)" \
	HELM_VALUES="$(HELM_VALUES)" \
	HELM_CASC_VALUES="$(HELM_CASC_VALUES)" \
	HELM_VALUES_FILES="$(HELM_VALUES_FILES)" \
	HELM_SET_ARGS="$(HELM_SET_ARGS)" \
	HELM_EXTRA_ARGS="$(HELM_EXTRA_ARGS)" \
	HELM_RENDER_OUTPUT_PATH="$(HELM_RENDER_OUTPUT_PATH)" \
	bash ./scripts/helm-render.sh

helm-diff: helm-repo-init
	@HELM_RELEASE="$(HELM_RELEASE)" \
	HELM_CHART="$(HELM_CHART)" \
	HELM_NAMESPACE="$(HELM_NAMESPACE)" \
	HELM_VALUES="$(HELM_VALUES)" \
	HELM_CASC_VALUES="$(HELM_CASC_VALUES)" \
	HELM_VALUES_FILES="$(HELM_VALUES_FILES)" \
	HELM_SET_ARGS="$(HELM_SET_ARGS)" \
	HELM_EXTRA_ARGS="$(HELM_EXTRA_ARGS)" \
	bash ./scripts/helm-diff.sh

helm-deploy:
	@HELM_RELEASE=$(HELM_RELEASE) \
	HELM_CHART=$(HELM_CHART) \
	HELM_NAMESPACE=$(HELM_NAMESPACE) \
	HELM_VALUES_FILES="$(HELM_VALUES) $(HELM_CASC_VALUES)" \
	HELM_SET_KV="$(HELM_SET_KV)" \
	HELM_SET_ARGS="$(HELM_SET_ARGS)" \
	HELM_SET_VERSION="$(HELM_SET_VERSION)" \
	HELM_SET_VERSION_KEY="$(HELM_SET_VERSION_KEY)" \
	HELM_IMAGE_NAME="$(HELM_IMAGE_NAME)" \
	HELM_IMAGE_TAG="$(HELM_IMAGE_TAG)" \
	HELM_IMAGE_NAME_KEY="$(HELM_IMAGE_NAME_KEY)" \
	HELM_IMAGE_TAG_KEY="$(HELM_IMAGE_TAG_KEY)" \
	HELM_EXTRA_ARGS="$(HELM_EXTRA_ARGS)" \
	bash ./scripts/helm-deploy.sh

helm-upgrade: helm-repo-init helm-deploy

helm-upgrade-init: helm-upgrade

helm-version:
	@DEPLOY_GIT_SHA="$(DEPLOY_GIT_SHA)" \
	HELM_APP_VERSION_KEY="$(HELM_APP_VERSION_KEY)" \
	HELM_IMAGE_TAG_KEY="$(HELM_IMAGE_TAG_KEY)" \
	HELM_RELEASE="$(HELM_RELEASE)" \
	HELM_CHART="$(HELM_CHART)" \
	HELM_NAMESPACE="$(HELM_NAMESPACE)" \
	HELM_VALUES="$(HELM_VALUES)" \
	HELM_CASC_VALUES="$(HELM_CASC_VALUES)" \
	HELM_VALUES_FILES="$(HELM_VALUES_FILES)" \
	HELM_SET_KV="$(HELM_SET_KV)" \
	HELM_SET_ARGS="$(HELM_SET_ARGS)" \
	HELM_IMAGE_NAME="$(HELM_IMAGE_NAME)" \
	HELM_IMAGE_NAME_KEY="$(HELM_IMAGE_NAME_KEY)" \
	HELM_EXTRA_ARGS="$(HELM_EXTRA_ARGS)" \
	HELM_REPO_NAME="$(HELM_REPO_NAME)" \
	HELM_REPO_URL="$(HELM_REPO_URL)" \
	K8S_TARGET_NAMESPACE="$(K8S_TARGET_NAMESPACE)" \
	K8S_RBAC_RESOURCES="$(K8S_RBAC_RESOURCES)" \
	K8S_RBAC_VERBS="$(K8S_RBAC_VERBS)" \
	DOCTL_KUBECONFIG_SAVE="$(DOCTL_KUBECONFIG_SAVE)" \
	DOCTL_ACCESS_TOKEN="$(DOCTL_ACCESS_TOKEN)" \
	DO_CLUSTER_NAME="$(DO_CLUSTER_NAME)" \
	MAKE_BIN="$(MAKE)" \
	bash ./scripts/helm-version.sh

k8s-deploy-preflight:
	@HELM_NAMESPACE=$(HELM_NAMESPACE) bash ./scripts/helm-preflight.sh

helm-preflight:
	@HELM_NAMESPACE=$(HELM_NAMESPACE) bash ./scripts/helm-preflight.sh

helm-deploy-preflight:
	@$(MAKE) helm-preflight HELM_NAMESPACE=$(HELM_NAMESPACE)

helm-upgrade-ci: helm-deploy-preflight helm-upgrade