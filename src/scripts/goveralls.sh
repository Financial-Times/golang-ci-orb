#!/bin/bash
goveralls -coverprofile=$COVERAGE_REPORT_FOLDER/coverage.out -service=circle-ci -repotoken=$COVERALLS_TOKEN
