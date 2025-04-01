#!/bin/bash
wget -c https://go.dev/dl/go"${GOLANG_VERSION}".linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local/ -xzf go"${GOLANG_VERSION}".linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin  # Add this line to include Go binaries from GOPATH

go get github.com/mattn/goveralls
go install github.com/mattn/goveralls
goveralls -coverprofile=coverage/coverage.out -service=circle-ci -repotoken="${COVERALLS_TOKEN}"
