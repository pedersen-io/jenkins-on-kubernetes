GIT_COMMIT_SHA ?= $(shell git rev-parse HEAD)
IMAGE_NAME = derekpedersen/build-php

build:
	docker build ./ \
		-t $(IMAGE_NAME):latest \
		-t $(IMAGE_NAME):$(GIT_COMMIT_SHA)

publish-docker: build
	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):$(GIT_COMMIT_SHA)
