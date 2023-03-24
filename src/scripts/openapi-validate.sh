#!/bin/bash
npm config set prefix "${HOME}/.local/"
export PATH=~/.local/bin/:$PATH
npm install -g @apidevtools/swagger-cli@4.0.4
swagger-cli validate "${FILE_PATH}"
