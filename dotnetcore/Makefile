GIT_COMMIT_SHA ?= $(shell git rev-parse HEAD)
IMAGE_NAME = derekpedersen/build-dotnetcore

build:
	docker build --no-cache ./ \
		-t $(IMAGE_NAME):latest \
		-t $(IMAGE_NAME):$(GIT_COMMIT_SHA)

publish-docker: build
	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):$(GIT_COMMIT_SHA)
