.PHONY: help ps build build-prod start fresh fresh-prod stop restart destroy \
	cache cache-clear migrate migrate migrate-fresh tests tests-html

CONTAINER_PHP=api
CONTAINER_REDIS=redis
CONTAINER_DATABASE=database

help: ## Print help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

auth: #authenticate with AWS
	aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 708016832646.dkr.ecr.eu-north-1.amazonaws.com
build: #build AWS prod image
	docker build -t prod-tourist-api-base-image .
push: #push to prod image
	docker tag prod-tourist-api-base-image:latest 708016832646.dkr.ecr.eu-north-1.amazonaws.com/prod-tourist-api-base-image:latest
	docker push 708016832646.dkr.ecr.eu-north-1.amazonaws.com/prod-tourist-api-base-image:latest
build-push:
	make build
	make push
