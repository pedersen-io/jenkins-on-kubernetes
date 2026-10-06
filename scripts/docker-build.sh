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

DOCKER_CONTEXT="${DOCKER_CONTEXT:-.}"
DOCKERFILE_PATH="${DOCKERFILE_PATH:-Dockerfile}"
DOCKER_TAGS="${DOCKER_TAGS:-latest}"

build_cmd=(docker build -f "${DOCKERFILE_PATH}")
for tag in ${DOCKER_TAGS}; do
    build_cmd+=(-t "${DOCKER_IMAGE_NAME}:${tag}")
done

if [[ -n "${DOCKER_BUILD_ARGS:-}" ]]; then
    # DOCKER_BUILD_ARGS is intentionally word-split for raw docker flags.
    # Example: --build-arg FOO=bar --platform linux/amd64
    # shellcheck disable=SC2206
    build_args=( ${DOCKER_BUILD_ARGS} )
    build_cmd+=("${build_args[@]}")
fi

build_cmd+=("${DOCKER_CONTEXT}")

echo "Building Docker image tags: ${DOCKER_IMAGE_NAME} [${DOCKER_TAGS}]"
printf ' %q' "${build_cmd[@]}"
printf '\n'

"${build_cmd[@]}"

echo "Build complete for ${DOCKER_IMAGE_NAME}"
