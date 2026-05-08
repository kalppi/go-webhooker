#!/bin/bash

set -e

ZONE="${ZONE:-europe-north1-a}"
INSTANCE="${INSTANCE:-terraform-instance}"
APP_PORT="${APP_PORT:-8080}"
FRONTEND_PORT="${FRONTEND_PORT:-80}"

IP=$(gcloud compute instances describe "${INSTANCE}" \
	--zone="${ZONE}" \
	--format='get(networkInterfaces[0].accessConfigs[0].natIP)')

API_URL="http://${IP}:${APP_PORT}"
FRONTEND_URL="http://${IP}:${FRONTEND_PORT}"

if [ "${FRONTEND_PORT}" = "80" ]; then
	FRONTEND_URL="http://${IP}"
fi

echo "API: ${API_URL}"
echo "Frontend: ${FRONTEND_URL}"
