#!/bin/bash
if ! command -v gh >/dev/null; then
  if command -v sudo >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y curl unzip
    curl -Lo gh.tar.gz https://github.com/cli/cli/releases/download/v2.86.0/gh_2.86.0_linux_amd64.tar.gz
    tar -xzf gh.tar.gz
    sudo cp gh_2.86.0_linux_amd64/bin/gh /usr/local/bin/
    rm -rf gh.tar.gz gh_2.86.0_linux_amd64
  else
    apt-get update
    apt-get install -y curl unzip
    curl -Lo gh.tar.gz https://github.com/cli/cli/releases/download/v2.86.0/gh_2.86.0_linux_amd64.tar.gz
    tar -xzf gh.tar.gz
    cp gh_2.86.0_linux_amd64/bin/gh /usr/local/bin/
    rm -rf gh.tar.gz gh_2.86.0_linux_amd64
  fi
fi
