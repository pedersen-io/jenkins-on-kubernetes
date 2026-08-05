export GIT_COMMIT_SHA = $(shell git rev-parse HEAD)

build:
	docker build ./ -t build-jenkins-base

publish-docker:
	docker tag build-jenkins-base derekpedersen/build-jenkins-base:latest
	docker push derekpedersen/build-jenkins-base:latest