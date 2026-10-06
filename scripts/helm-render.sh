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

RENDER_OUTPUT_PATH="${HELM_RENDER_OUTPUT_PATH:-./helm-rendered.yaml}"
VALUES_FILES="${HELM_VALUES_FILES:-}"
if [[ -z "${VALUES_FILES}" ]]; then
    VALUES_FILES="${HELM_VALUES:-} ${HELM_CASC_VALUES:-}"
fi

cmd=(helm template "${HELM_RELEASE}" "${HELM_CHART}" --namespace "${HELM_NAMESPACE}")
for values_file in ${VALUES_FILES}; do
    if [[ -n "${values_file}" ]]; then
        cmd+=(-f "${values_file}")
    fi
done

if [[ -n "${HELM_SET_ARGS:-}" ]]; then
    # shellcheck disable=SC2206
    set_args=( ${HELM_SET_ARGS} )
    cmd+=("${set_args[@]}")
fi

if [[ -n "${HELM_EXTRA_ARGS:-}" ]]; then
    # shellcheck disable=SC2206
    extra_args=( ${HELM_EXTRA_ARGS} )
    cmd+=("${extra_args[@]}")
fi

echo "Rendering manifests to ${RENDER_OUTPUT_PATH}"
printf ' %q' "${cmd[@]}"
printf '\n'

"${cmd[@]}" >"${RENDER_OUTPUT_PATH}"

echo "Render complete: ${RENDER_OUTPUT_PATH}"
