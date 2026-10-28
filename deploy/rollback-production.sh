#!/usr/bin/env bash
set -Eeuo pipefail

: "${DEPLOY_PATH:?DEPLOY_PATH is required}"

CURRENT_LINK="${DEPLOY_PATH}/current"

if [[ ! -L "${CURRENT_LINK}" ]]; then
  echo "No current production release exists." >&2
  exit 1
fi

CURRENT_RELEASE="$(readlink -f "${CURRENT_LINK}")"
PREVIOUS_FILE="${CURRENT_RELEASE}/previous-release"

if [[ ! -f "${PREVIOUS_FILE}" ]]; then
  echo "No rollback information exists." >&2
  exit 1
fi

PREVIOUS_RELEASE="$(head -n 1 "${PREVIOUS_FILE}")"

if [[ -z "${PREVIOUS_RELEASE}" \
      || ! -f "${PREVIOUS_RELEASE}/compose.yaml" \
      || ! -f "${PREVIOUS_RELEASE}/release.env" ]]; then
  echo "No valid previous release is available." >&2
  exit 1
fi

docker compose \
  --project-name digital-career-hub \
  --env-file "${PREVIOUS_RELEASE}/release.env" \
  -f "${PREVIOUS_RELEASE}/compose.yaml" \
  pull

docker compose \
  --project-name digital-career-hub \
  --env-file "${PREVIOUS_RELEASE}/release.env" \
  -f "${PREVIOUS_RELEASE}/compose.yaml" \
  up -d --remove-orphans --wait --wait-timeout 180

ln -sfn "${PREVIOUS_RELEASE}" "${CURRENT_LINK}"

echo "Rollback completed: ${PREVIOUS_RELEASE}"
