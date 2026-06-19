docker_image_name=flyway-migration
docker_image_version=latest
platform=linux/amd64

.PHONY: build
build:
	@docker build --platform $(platform) -t $(docker_image_name):$(docker_image_version) .
