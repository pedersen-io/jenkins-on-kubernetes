#!/usr/bin/env bash
set -eu

IMAGE_NAME="${1:-}"
if [[ -z "${IMAGE_NAME}" ]]; then
  echo "Usage: $0 <image-name>" >&2
  exit 1
fi

mkdir -p .trivy/reports
if ! command -v trivy >/dev/null 2>&1; then
  curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
fi

SAFE_NAME="${IMAGE_NAME//\//-}"
trivy image --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed --format json --output ".trivy/reports/${SAFE_NAME}.json" "${IMAGE_NAME}:latest" || true
trivy image --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed --format table --output ".trivy/reports/${SAFE_NAME}.txt" "${IMAGE_NAME}:latest" || true

echo "Trivy scan completed; build continues because this is report-only mode."
