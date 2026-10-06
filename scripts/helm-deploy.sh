#!/usr/bin/env bash
set -euo pipefail

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Required command not found: $1"
        exit 1
    fi
}

require_cmd helm

if [[ -z "${HELM_RELEASE:-}" ]]; then
    echo "HELM_RELEASE is required"
    exit 1
fi

if [[ -z "${HELM_CHART:-}" ]]; then
    echo "HELM_CHART is required"
    exit 1
fi

if [[ -z "${HELM_NAMESPACE:-}" ]]; then
    echo "HELM_NAMESPACE is required"
    exit 1
fi

VALUES_FILES="${HELM_VALUES_FILES:-}"
if [[ -z "${VALUES_FILES}" ]]; then
    VALUES_FILES="${HELM_VALUES:-} ${HELM_CASC_VALUES:-}"
fi

cmd=(helm upgrade --install "${HELM_RELEASE}" "${HELM_CHART}" --namespace "${HELM_NAMESPACE}")

for values_file in ${VALUES_FILES}; do
    if [[ -n "${values_file}" ]]; then
        cmd+=(-f "${values_file}")
    fi
done

if [[ -n "${HELM_SET_KV:-}" ]]; then
    for kv in ${HELM_SET_KV}; do
        cmd+=(--set-string "${kv}")
    done
fi

if [[ -n "${HELM_SET_VERSION_KEY:-}" && -n "${HELM_SET_VERSION:-}" ]]; then
    cmd+=(--set-string "${HELM_SET_VERSION_KEY}=${HELM_SET_VERSION}")
fi

if [[ -n "${HELM_IMAGE_NAME_KEY:-}" && -n "${HELM_IMAGE_NAME:-}" ]]; then
    cmd+=(--set-string "${HELM_IMAGE_NAME_KEY}=${HELM_IMAGE_NAME}")
fi

if [[ -n "${HELM_IMAGE_TAG_KEY:-}" && -n "${HELM_IMAGE_TAG:-}" ]]; then
    cmd+=(--set-string "${HELM_IMAGE_TAG_KEY}=${HELM_IMAGE_TAG}")
fi

if [[ -n "${HELM_SET_ARGS:-}" ]]; then
    # HELM_SET_ARGS is intentionally word-split to support repeated flags.
    # Example: --set key=value --set-string key2=value2
    # shellcheck disable=SC2206
    set_args=( ${HELM_SET_ARGS} )
    cmd+=("${set_args[@]}")
fi

if [[ -n "${HELM_EXTRA_ARGS:-}" ]]; then
    # HELM_EXTRA_ARGS is intentionally word-split for optional helm flags.
    # Example: --atomic --timeout 10m --create-namespace
    # shellcheck disable=SC2206
    extra_args=( ${HELM_EXTRA_ARGS} )
    cmd+=("${extra_args[@]}")
fi

echo "Running Helm deploy command:"
printf ' %q' "${cmd[@]}"
printf '\n'

"${cmd[@]}"
