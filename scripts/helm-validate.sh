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

tmpl_cmd=(helm template "${HELM_RELEASE}" "${HELM_CHART}" --namespace "${HELM_NAMESPACE}")
for values_file in ${VALUES_FILES}; do
    if [[ -n "${values_file}" ]]; then
        tmpl_cmd+=(-f "${values_file}")
    fi
done

if [[ -n "${HELM_SET_ARGS:-}" ]]; then
    # shellcheck disable=SC2206
    set_args=( ${HELM_SET_ARGS} )
    tmpl_cmd+=("${set_args[@]}")
fi

if [[ -n "${HELM_EXTRA_ARGS:-}" ]]; then
    # shellcheck disable=SC2206
    extra_args=( ${HELM_EXTRA_ARGS} )
    tmpl_cmd+=("${extra_args[@]}")
fi

echo "Rendering chart for validation:"
printf ' %q' "${tmpl_cmd[@]}"
printf '\n'

"${tmpl_cmd[@]}" >/dev/null

echo "Template render validation passed."

if [[ "${HELM_VALIDATE_SERVER_DRY_RUN:-0}" == "1" ]]; then
    require_cmd kubectl
    echo "Running kubectl server-side dry run validation..."
    "${tmpl_cmd[@]}" | kubectl apply --dry-run=server -f - >/dev/null
    echo "Server-side dry run validation passed."
fi
