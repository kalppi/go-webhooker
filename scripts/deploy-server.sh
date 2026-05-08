#!/bin/bash

set -e

# Configuration
SERVICE="${SERVICE:-api}"
APP_NAME="go-webhooker-${SERVICE}"
APP_PORT="${APP_PORT:-8080}"
APP_INTERNAL_PORT="${APP_INTERNAL_PORT:-8080}"

echo "Deploying service: ${SERVICE}"
echo "Container name: ${APP_NAME}"

# Stop and remove existing container
sudo docker stop ${APP_NAME} || true
sudo docker rm ${APP_NAME} || true

# Build the service
echo "Building Docker image..."
sudo DOCKER_BUILDKIT=1 docker build --target ${SERVICE} -t ${APP_NAME}:latest .

# Run the service
echo "Starting container..."
sudo docker run -d \
  --name ${APP_NAME} \
  --restart unless-stopped \
  -e PORT=${APP_INTERNAL_PORT} \
  -p ${APP_PORT}:${APP_INTERNAL_PORT} \
  ${APP_NAME}:latest

echo "✓ Service ${SERVICE} deployed successfully on port ${APP_PORT}"
