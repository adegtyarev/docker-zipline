DOCKER_USERNAME?=$(USER)
DOCKER_REPO?=$(DOCKER_USERNAME)
PYTHON?=python3
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

build-images: build-zipline-jupyter

build-zipline:
	docker build \
		--build-arg ZIPLINE_REF=$(ZIPLINE_REF) \
		-t zipline:$(PYTHON) \
		-f $(PYTHON)/Dockerfile \
		$(PYTHON)
	docker tag zipline:$(PYTHON) $(DOCKER_REPO)/zipline:$(PYTHON)

build-zipline-talib: build-zipline-%: build-zipline
	docker build \
		--build-arg TALIB_REF=$(TALIB_REF) \
		-t zipline:$* \
		-f $(PYTHON)/Dockerfile.$* \
		$(PYTHON)
	docker tag zipline:$* $(DOCKER_REPO)/zipline:$(PYTHON)-$*

build-zipline-dev: build-zipline-%: build-zipline-talib
	docker build \
		-t zipline:$* \
		-f $(PYTHON)/Dockerfile.$* \
		$(PYTHON)
	docker tag zipline:$* $(DOCKER_REPO)/zipline:$(PYTHON)-$*

build-zipline-jupyter: build-zipline-%: build-zipline-dev
	docker build \
		-t zipline:$* \
		-f $(PYTHON)/Dockerfile.$* \
		$(PYTHON)
	docker tag zipline:$* $(DOCKER_REPO)/zipline:$(PYTHON)-$*

push-images: \
	push-zipline \
	push-zipline-python-dev \
	push-zipline-python-jupyter \
	push-zipline-python-talib

push-latest: \
	push-zipline-dev \
	push-zipline-jupyter \
	push-zipline-latest \
	push-zipline-talib

push-auxilary-images: \
	push-aux-dev \
	push-aux-jupyter \
	push-aux-talib \
	push-aux-zipline

push-zipline: build-zipline
	docker push $(DOCKER_REPO)/zipline:$(PYTHON)

push-zipline-python-dev \
push-zipline-python-jupyter \
push-zipline-python-talib: \
	push-zipline-python-%: build-zipline-%
	docker push $(DOCKER_REPO)/zipline:$(PYTHON)-$*

push-zipline-latest: push-zipline-%: build-zipline
	test "$(PYTHON)" = "python3" || \
		{ echo Tag 'latest' only used when $$PYTHON=python3; false; }
	docker tag zipline:$(PYTHON) $(DOCKER_REPO)/zipline:$*
	docker push $(DOCKER_REPO)/zipline:$*

push-zipline-dev push-zipline-talib push-zipline-jupyter: push-zipline-%: build-zipline-%
	test "$(PYTHON)" = "python3" || \
		{ echo Only used when $$PYTHON=python3 but got $(PYTHON) instead; false; }
	docker tag zipline:$* $(DOCKER_REPO)/zipline:$*
	docker push $(DOCKER_REPO)/zipline:$*

push-aux-zipline: build-zipline
	docker tag zipline:$(PYTHON) $(DOCKER_REPO)/zipline:$(BRANCH)-$(PYTHON)
	docker push $(DOCKER_REPO)/zipline:$(BRANCH)-$(PYTHON)

push-aux-dev \
push-aux-jupyter \
push-aux-talib: push-aux-%: build-zipline-%
	docker tag zipline:$* $(DOCKER_REPO)/zipline:$(BRANCH)-$(PYTHON)-$*
	docker push $(DOCKER_REPO)/zipline:$(BRANCH)-$(PYTHON)-$*
