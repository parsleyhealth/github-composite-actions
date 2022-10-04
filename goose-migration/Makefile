docker_image_name=goose-action
docker_image_version=latest

.PHONY: build
build:
	@cd docker && docker build -t $(docker_image_name):$(docker_image_version) .
