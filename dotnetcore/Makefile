export GIT_COMMIT_SHA = $(shell git rev-parse HEAD)

build:
	docker build ./ -t build-dotnetcore

publish-docker:
	docker tag build-dotnetcore derekpedersen/build-dotnetcore:latest
	docker push derekpedersen/build-dotnetcore:latest
