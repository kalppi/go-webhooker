#!/bin/bash

set -e

APP_NAME="my-go-app"
APP_PORT="${APP_PORT:-8080}"
APP_INTERNAL_PORT="${APP_INTERNAL_PORT:-8080}"

sudo docker stop ${APP_NAME} || true
sudo docker rm ${APP_NAME} || true

sudo DOCKER_BUILDKIT=1 docker build -t ${APP_NAME} .

sudo docker run -d \
  --name ${APP_NAME} \
  --restart unless-stopped \
  -e PORT=${APP_INTERNAL_PORT} \
  -p ${APP_PORT}:${APP_INTERNAL_PORT} \
  ${APP_NAME}
