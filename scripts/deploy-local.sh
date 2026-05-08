#!/bin/bash

set -e

# Multi-service deployment script
# Deploy services to remote server with specified configuration

ZONE="${ZONE:-europe-north1-a}"
INSTANCE="${INSTANCE:-terraform-instance}"
REMOTE_DIR="~/app"
SERVICE="${SERVICE:-api}"
APP_PORT="${APP_PORT:-8080}"
APP_INTERNAL_PORT="${APP_INTERNAL_PORT:-8080}"

echo "Preparing deployment..."
echo "  Service: ${SERVICE}"
echo "  Zone: ${ZONE}"
echo "  Instance: ${INSTANCE}"
echo "  External Port: ${APP_PORT}"
echo "  Internal Port: ${APP_INTERNAL_PORT}"

# Upload code to remote
tar cz \
  --exclude='.git' \
  --exclude='.idea' \
  --exclude='node_modules' \
  --exclude='.terraform' \
  --exclude='terraform.tfstate*' \
  . | gcloud compute ssh ${INSTANCE} \
    --zone=${ZONE} \
    --command="
      mkdir -p ${REMOTE_DIR} &&
      tar xz -C ${REMOTE_DIR}
    "

echo "Deploying service remotely..."

# Deploy on remote
gcloud compute ssh ${INSTANCE} \
  --zone=${ZONE} \
  --command="
    cd ${REMOTE_DIR} &&
    chmod +x scripts/deploy-server.sh &&
    SERVICE=${SERVICE} APP_PORT=${APP_PORT} APP_INTERNAL_PORT=${APP_INTERNAL_PORT} ./scripts/deploy-server.sh
  "

# Get instance IP
IP=$(gcloud compute instances describe ${INSTANCE} \
  --zone=${ZONE} \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo ""
echo "✓ Deployment complete!"
echo "Service URL: http://${IP}:${APP_PORT}"
