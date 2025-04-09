#!/bin/bash

# Check if the executor is compose-executor
if [ "$EXECUTOR_NAME" != "compose-executor" ]; then
  echo "Executor is not compose-executor. Skipping integration tests."
  exit 0
fi

# Check if the required file exists
if [ ! -f "docker-compose-tests.yml" ]; then
  echo "File docker-compose-tests.yml not found. Exiting with status 0."
  exit 0
fi

# Run the integration tests using docker-compose
docker-compose -f docker-compose-tests.yml up --abort-on-container-exit --build --exit-code-from test-runner && \
export "TESTS_STATUS_CODE"="$(docker inspect test-runner --format="{{.State.ExitCode}}")" && \
docker-compose -f docker-compose-tests.yml down && \
exit "$TESTS_STATUS_CODE"
