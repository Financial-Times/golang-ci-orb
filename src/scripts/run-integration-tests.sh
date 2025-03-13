#!/bin/bash

docker-compose -f docker-compose-tests.yml up --abort-on-container-exit --build --exit-code-from test-runner && docker cp test-runner:"${COVERAGE_REPORT_FOLDER}" . && export "TESTS_STATUS_CODE"="$(docker inspect test-runner --format="{{.State.ExitCode}}")" && docker-compose -f docker-compose-tests.yml down && exit "$TESTS_STATUS_CODE"