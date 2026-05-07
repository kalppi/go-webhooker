#!/bin/bash

set -e

ZONE="europe-north1-a"
INSTANCE="terraform-instance"
APP_PORT="${APP_PORT:-8080}"

IP=$(gcloud compute instances describe "${INSTANCE}" \
	--zone="${ZONE}" \
	--format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo "http://${IP}:${APP_PORT}"
