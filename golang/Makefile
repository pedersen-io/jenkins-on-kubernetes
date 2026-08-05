export GIT_COMMIT_SHA = $(shell git rev-parse HEAD)

build:
	docker build ./ -t build-golang

publish-docker:
	docker tag build-golang derekpedersen/build-golang:latest
	docker push derekpedersen/build-golang:latest