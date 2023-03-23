#!/bin/bash
docker build --build-arg GITHUB_USERNAME=${GITHUB_USERNAME} --build-arg GITHUB_TOKEN=${GITHUB_TOKEN} .
