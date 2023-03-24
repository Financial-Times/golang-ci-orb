#!/bin/bash
curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh| sh -s -- -b "$(go env GOPATH)"/bin "${GOLANGCI_LINT_VERSION}"

golangci-lint run --new-from-rev="$(git rev-parse refs/remotes/origin/HEAD)" --config .golangci.yml --build-tags=integration
