build: 
	set -e; \
	DOCKER_BUILDKIT=1 \
	docker build \
	-f Dockerfile \
	--build-arg RUBY_VERSION="2.6.5" \
	--build-arg PG_MAJOR="11" \
	--build-arg NODE_MAJOR="11" \
	--build-arg YARN_VERSION="1.22.4" \
	--build-arg BUNDLER_VERSION="2.1.0" \
	. \
	-t quay.io/lewagon/mlflow:latest;

push: 
	docker push quay.io/lewagon/mlflow:latest

deploy:
	helm upgrade mflow . --install \
	--atomic --cleanup-on-fail --timeout=3m0s \
	--set-string dbConnectionString=$(db_connection_string) \
	--set-string artifactStorage.key=$(spaces_key) \
	--set-string artifactStorage.secret=$(spaces_secret)