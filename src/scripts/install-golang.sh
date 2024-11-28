#!/bin/bash

wget -c https://go.dev/dl/go"${GOLANG_VERSION}".linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local/ -xzf go"${GOLANG_VERSION}".linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
