region = us-east-2
IMAGE = aws-cli
RUN = docker run -v ${HOME}/.aws/credentials:/root/.aws/credentials:ro -ti

test:						## Run code coverage unit tests
	@DOCKER_BUILDKIT=1 docker build -t $(IMAGE)-test -f Dockerfile_test .
	@$(RUN) $(IMAGE)-test

build:						## Build the docker image
	@docker build -t $(IMAGE) -f Dockerfile .

run: 						## Run the docker image
	@$(RUN) $(IMAGE) aws-cli.py -r $(region)

help:						## Show this help
	@printf "\nCommands:\n"
	@egrep '^[$$()% a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "- \033[36m%-20s\033[0m %s\n", $$1, $$2}'
