#!/bin/bash -e
cd $(dirname $0)/../
rm -f lambda-package.zip
docker-compose -f build/docker-compose.yml up
