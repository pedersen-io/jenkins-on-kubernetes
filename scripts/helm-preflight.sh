#!/usr/bin/env bash
set -euo pipefail

require_cmd() {
	if ! command -v "$1" >/dev/null 2>&1; then
		echo "Required command not found: $1"
		exit 1
	fi
}

ACCESS_TOKEN="${DIGITALOCEAN_ACCESS_TOKEN:-${DOCTL_ACCESS_TOKEN:-}}"
CLUSTER_NAME="${DIGITALOCEAN_K8S_CLUSTER:-${DO_CLUSTER_NAME:-}}"
TARGET_NAMESPACE="${K8S_TARGET_NAMESPACE:-${HELM_NAMESPACE:-jenkins}}"
RBAC_RESOURCES="${K8S_RBAC_RESOURCES:-secrets}"
RBAC_VERBS="${K8S_RBAC_VERBS:-get list create update patch}"
DOCTL_KUBECONFIG_SAVE="${DOCTL_KUBECONFIG_SAVE:-1}"

require_cmd kubectl

set +x

if [[ "${DOCTL_KUBECONFIG_SAVE}" == "1" ]]; then
	require_cmd doctl

	if [[ -z "${ACCESS_TOKEN}" ]]; then
		echo "DIGITALOCEAN_ACCESS_TOKEN (or DOCTL_ACCESS_TOKEN) is required when DOCTL_KUBECONFIG_SAVE=1"
		exit 1
	fi

	if [[ -z "${CLUSTER_NAME}" ]]; then
		echo "DIGITALOCEAN_K8S_CLUSTER (or DO_CLUSTER_NAME) is required when DOCTL_KUBECONFIG_SAVE=1"
		exit 1
	fi

	echo "Initializing doctl and loading kubeconfig for cluster: ${CLUSTER_NAME}"
	doctl auth init --access-token "${ACCESS_TOKEN}"
	doctl kubernetes cluster kubeconfig save "${CLUSTER_NAME}"
else
	echo "Skipping doctl kubeconfig save (DOCTL_KUBECONFIG_SAVE=${DOCTL_KUBECONFIG_SAVE})"
fi

echo "HOME=${HOME}"
echo "KUBECONFIG=${KUBECONFIG:-<unset>}"
if [[ -n "${KUBECONFIG:-}" ]]; then
	ls -l "${KUBECONFIG}"
else
	ls -l "${HOME}/.kube/config"
fi

echo "Active kubectl context:"
kubectl config current-context
echo "Cluster connectivity:"
kubectl cluster-info

echo "Caller identity (best effort):"
kubectl auth whoami || true

echo "RBAC preflight checks in namespace ${TARGET_NAMESPACE}"
for resource in ${RBAC_RESOURCES}; do
	for verb in ${RBAC_VERBS}; do
		allowed="$(kubectl auth can-i "${verb}" "${resource}" -n "${TARGET_NAMESPACE}" 2>/dev/null || true)"
		echo "can-i ${verb} ${resource} -n ${TARGET_NAMESPACE} => ${allowed}"
		if [[ "${allowed}" != "yes" ]]; then
			echo "RBAC check failed: missing '${verb}' permission on ${resource} in namespace ${TARGET_NAMESPACE}"
			exit 1
		fi
	done
done
