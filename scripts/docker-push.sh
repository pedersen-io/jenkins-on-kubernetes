#!/usr/bin/env bash
set -euo pipefail

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Required command not found: $1"
        exit 1
    fi
}

require_cmd docker

if [[ -z "${DOCKER_IMAGE_NAME:-}" ]]; then
    echo "DOCKER_IMAGE_NAME is required"
    exit 1
fi

DOCKER_TAGS="${DOCKER_TAGS:-latest}"

for tag in ${DOCKER_TAGS}; do
    echo "Pushing ${DOCKER_IMAGE_NAME}:${tag}"
    docker push "${DOCKER_IMAGE_NAME}:${tag}"
done

echo "Push complete for ${DOCKER_IMAGE_NAME}"
