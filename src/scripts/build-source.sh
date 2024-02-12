#!/bin/bash
git config --global --unset url."ssh://git@github.com".insteadOf
export GOPRIVATE="github.com/Financial-Times"
git config --global url."https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com".insteadOf "https://github.com"
go mod download
go build -mod=readonly -v ./...
