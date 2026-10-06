#!/usr/bin/env bash
set -euo pipefail

require_var() {
    local name="$1"
    local value="${!name:-}"
    if [[ -z "${value}" ]]; then
        echo "${name} is required"
        exit 1
    fi
}

require_var DEPLOY_GIT_SHA
require_var HELM_IMAGE_TAG_KEY

HELM_APP_VERSION_KEY="${HELM_APP_VERSION_KEY:-appVersion}"
MAKE_BIN="${MAKE_BIN:-make}"

cmd=(
    "${MAKE_BIN}" helm-upgrade-ci
    "HELM_SET_VERSION_KEY=${HELM_APP_VERSION_KEY}"
    "HELM_SET_VERSION=${DEPLOY_GIT_SHA}"
    "HELM_IMAGE_TAG_KEY=${HELM_IMAGE_TAG_KEY}"
    "HELM_IMAGE_TAG=${DEPLOY_GIT_SHA}"
)

# Preserve optional Helm/deploy configuration that may be provided by callers.
pass_through_vars=(
    HELM_RELEASE
    HELM_CHART
    HELM_NAMESPACE
    HELM_VALUES
    HELM_CASC_VALUES
    HELM_VALUES_FILES
    HELM_SET_KV
    HELM_SET_ARGS
    HELM_IMAGE_NAME
    HELM_IMAGE_NAME_KEY
    HELM_EXTRA_ARGS
    HELM_REPO_NAME
    HELM_REPO_URL
    K8S_TARGET_NAMESPACE
    K8S_RBAC_RESOURCES
    K8S_RBAC_VERBS
    DOCTL_KUBECONFIG_SAVE
    DOCTL_ACCESS_TOKEN
    DO_CLUSTER_NAME
)

for var_name in "${pass_through_vars[@]}"; do
    var_value="${!var_name:-}"
    if [[ -n "${var_value}" ]]; then
        cmd+=("${var_name}=${var_value}")
    fi
done

echo "Running Helm version workflow:"
printf ' %q' "${cmd[@]}"
printf '\n'

"${cmd[@]}"
