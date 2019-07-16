DOCKER_USERNAME?=$(USER)
DOCKER_REPO?=$(DOCKER_USERNAME)
FLAVOR?=python3
ZIPLINE_REF?=master
TALIB_REF?=0.4.0
BRANCH?=$(shell git symbolic-ref --short -q HEAD)

all: build-zipline

docker-login:
	@test -n "$(DOCKER_PASSWORD)" || \
		{ echo Set $$DOCKER_PASSWORD env in order to make login; false; }
	@echo "$(DOCKER_PASSWORD)" | docker login \
		--username "$(DOCKER_USERNAME)" \
		--password-stdin \
		$(DOCKER_SERVER)

build-images: build-zipline-jupyter build-zipline-jupyterlab

build-zipline:
	docker build \
		--build-arg ZIPLINE_REF=$(ZIPLINE_REF) \
		-t zipline:$(FLAVOR) \
		-f $(FLAVOR)/Dockerfile \
		$(FLAVOR)
	docker tag zipline:$(FLAVOR) $(DOCKER_REPO)/zipline:$(FLAVOR)

build-zipline-talib: build-zipline-%: build-zipline
	docker build \
		--build-arg TALIB_REF=$(TALIB_REF) \
		-t zipline:$* \
		-f $(FLAVOR)/Dockerfile.$* \
		$(FLAVOR)
	docker tag zipline:$* $(DOCKER_REPO)/zipline:$(FLAVOR)-$*

build-zipline-dev: build-zipline-%: build-zipline-talib
	docker build \
		-t zipline:$* \
		-f $(FLAVOR)/Dockerfile.$* \
		$(FLAVOR)
	docker tag zipline:$* $(DOCKER_REPO)/zipline:$(FLAVOR)-$*

build-zipline-jupyter \
build-zipline-jupyterlab: build-zipline-%: build-zipline-dev
	docker build \
		-t zipline:$* \
		-f $(FLAVOR)/Dockerfile.$* \
		$(FLAVOR)
	docker tag zipline:$* $(DOCKER_REPO)/zipline:$(FLAVOR)-$*

push-images: \
	push-zipline \
	push-zipline-python-dev \
	push-zipline-python-jupyter \
	push-zipline-python-jupyterlab \
	push-zipline-python-talib

push-latest: \
	push-zipline-dev \
	push-zipline-jupyter \
	push-zipline-jupyterlab \
	push-zipline-latest \
	push-zipline-talib

push-auxilary-images: \
	push-aux-dev \
	push-aux-jupyter \
	push-aux-jupyterlab \
	push-aux-talib \
	push-aux-zipline

push-zipline: build-zipline
	docker push $(DOCKER_REPO)/zipline:$(FLAVOR)

push-zipline-python-dev \
push-zipline-python-jupyter \
push-zipline-python-jupyterlab \
push-zipline-python-talib: \
	push-zipline-python-%: build-zipline-%
	docker push $(DOCKER_REPO)/zipline:$(FLAVOR)-$*

push-zipline-latest: push-zipline-%: build-zipline
	test "$(FLAVOR)" = "python3" || \
		{ echo Tag 'latest' only used when $$FLAVOR=python3; false; }
	docker tag zipline:$(FLAVOR) $(DOCKER_REPO)/zipline:$*
	docker push $(DOCKER_REPO)/zipline:$*

push-zipline-dev \
push-zipline-jupyter \
push-zipline-jupyterlab \
push-zipline-talib: \
	push-zipline-%: build-zipline-%
	test "$(FLAVOR)" = "python3" || \
		{ echo Only used when $$FLAVOR=python3 but got $(FLAVOR) instead; false; }
	docker tag zipline:$* $(DOCKER_REPO)/zipline:$*
	docker push $(DOCKER_REPO)/zipline:$*

push-aux-zipline: build-zipline
	docker tag zipline:$(FLAVOR) $(DOCKER_REPO)/zipline:$(BRANCH)-$(FLAVOR)
	docker push $(DOCKER_REPO)/zipline:$(BRANCH)-$(FLAVOR)

push-aux-dev \
push-aux-jupyter \
push-aux-jupyterlab \
push-aux-talib: push-aux-%: build-zipline-%
	docker tag zipline:$* $(DOCKER_REPO)/zipline:$(BRANCH)-$(FLAVOR)-$*
	docker push $(DOCKER_REPO)/zipline:$(BRANCH)-$(FLAVOR)-$*
