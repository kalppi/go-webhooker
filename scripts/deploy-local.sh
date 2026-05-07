#!/bin/bash

set -e

ZONE="europe-north1-a"
INSTANCE="terraform-instance"
REMOTE_DIR="~/app"
APP_PORT="${APP_PORT:-8080}"

tar cz \
  --exclude='.git' \
  --exclude='.idea' \
  --exclude='node_modules' \
  . | gcloud compute ssh ${INSTANCE} \
    --zone=${ZONE} \
    --command="
      mkdir -p ${REMOTE_DIR} &&
      tar xz -C ${REMOTE_DIR}
    "

gcloud compute ssh ${INSTANCE} \
  --zone=${ZONE} \
  --command="
    cd ${REMOTE_DIR} &&
    chmod +x scripts/deploy-server.sh &&
    APP_PORT=${APP_PORT} ./scripts/deploy-server.sh
  "

IP=$(gcloud compute instances describe ${INSTANCE} \
  --zone=${ZONE} \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo "http://${IP}:${APP_PORT}"
