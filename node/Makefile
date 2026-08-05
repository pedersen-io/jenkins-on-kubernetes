export GIT_COMMIT_SHA = $(shell git rev-parse HEAD)

build:
	docker build ./ -t build-node

publish-docker:
	docker tag build-node derekpedersen/build-node:latest
	docker push derekpedersen/build-node:latest