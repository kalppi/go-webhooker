#!/bin/bash

set -e

APP_NAME="my-go-app"

sudo docker stop ${APP_NAME} || true
sudo docker rm ${APP_NAME} || true

sudo DOCKER_BUILDKIT=1 docker build -t ${APP_NAME} .

sudo docker run -d \
  --name ${APP_NAME} \
  --restart unless-stopped \
  -p 8080:8080 \
  ${APP_NAME}
