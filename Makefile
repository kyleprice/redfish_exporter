

GO           ?= go
GOFMT        ?= $(GO)fmt

BIN_DIR ?= $(shell pwd)/build
VERSION ?= $(shell cat VERSION)
REVERSION ?= $(shell git log -1 --pretty="%H")
BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
TIME ?= $(shell date --rfc-3339=seconds)
DOCKER ?= $(shell { command -v podman || command -v docker; } 2>/dev/null)

all: fmt build

build: |
	@echo ">> building binaries"
	$(GO) build -o build/redfish_exporter -ldflags  '-X "main.Version=$(VERSION)" -X  "main.BuildRevision=$(REVERSION)" -X  "main.BuildBranch=$(BRANCH)" -X "main.BuildTime=$(TIME)"'

fmt:
	@echo ">> format code style"
	$(GOFMT) -w $$(find . -path ./vendor -prune -o -name '*.go' -print)

docker-build:
	$(DOCKER) build -t redfish_exporter .

clean:
	rm -rf $(BIN_DIR)

.PHONY: all fmt build docker-build docker-test-emulator clean