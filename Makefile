#This makefile is used by ci-operator

CGO_ENABLED=0
GOOS=linux
CORE_IMAGES=./cmd/bash ./cmd/controller ./cmd/entrypoint ./cmd/gsutil ./cmd/kubeconfigwriter ./cmd/nop ./cmd/webhook ./cmd/creds-init ./cmd/git-init
CORE_IMAGES_WITH_GIT=./cmd/creds-init ./cmd/git-init

# Install core images
install:
	go install $(CORE_IMAGES)
.PHONY: install

# Run E2E tests on OpenShift
test-e2e:
	./openshift/e2e-tests-openshift.sh
.PHONY: test-e2e

# Generate Dockerfiles used by ci-operator. The files need to be committed manually.
generate-dockerfiles:
	./openshift/ci-operator/generate-dockerfiles.sh openshift/ci-operator/Dockerfile-git.in openshift/ci-operator/knative-images $(CORE_IMAGES)
.PHONY: generate-dockerfiles
