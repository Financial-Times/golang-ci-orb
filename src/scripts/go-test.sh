#!/bin/bash

if [ "$EXECUTOR_NAME" = "compose-executor" ]; then
  echo "Executor is compose-executor. Running tests without tags."
  go test -mod=readonly -race -cover -coverprofile="${COVERAGE_REPORT_FOLDER}"/coverage.out ./...
else
  echo "Executor is not compose-executor. Running tests with integration tags."
  go test -tags=integration -mod=readonly -race -cover -coverprofile="${COVERAGE_REPORT_FOLDER}"/coverage.out ./...
fi
