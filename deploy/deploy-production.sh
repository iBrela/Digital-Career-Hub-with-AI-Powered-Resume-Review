#!/usr/bin/env bash
set -Eeuo pipefail

: "${DEPLOY_PATH:?DEPLOY_PATH is required}"
: "${RELEASE_SHA:?RELEASE_SHA is required}"

RELEASE_DIR="${DEPLOY_PATH}/releases/${RELEASE_SHA}"
CURRENT_LINK="${DEPLOY_PATH}/current"
PREVIOUS_RELEASE=""

if [[ ! -d "${RELEASE_DIR}" ]]; then
  echo "Release directory does not exist: ${RELEASE_DIR}" >&2
  exit 1
fi

if [[ -e "${CURRENT_LINK}" && ! -L "${CURRENT_LINK}" ]]; then
  echo "${CURRENT_LINK} exists but is not a symbolic link." >&2
  exit 1
fi

if [[ -L "${CURRENT_LINK}" ]]; then
  PREVIOUS_RELEASE="$(readlink -f "${CURRENT_LINK}" || true)"
fi

printf '%s\n' "${PREVIOUS_RELEASE}" \
  > "${RELEASE_DIR}/previous-release"

chmod 600 \
  "${RELEASE_DIR}/backend.env" \
  "${RELEASE_DIR}/release.env"

if [[ -f "${DEPLOY_PATH}/compose.yaml" \
      && ! -L "${DEPLOY_PATH}/compose.yaml" \
      && ! -f "${DEPLOY_PATH}/compose.client-initial.yaml" ]]; then
  cp -p \
    "${DEPLOY_PATH}/compose.yaml" \
    "${DEPLOY_PATH}/compose.client-initial.yaml"
fi

compose_for() {
  local release_dir="$1"
  shift

  docker compose \
    --project-name digital-career-hub \
    --env-file "${release_dir}/release.env" \
    -f "${release_dir}/compose.yaml" \
    "$@"
}

deploy_release() {
  local release_dir="$1"

  compose_for "${release_dir}" pull \
    && compose_for "${release_dir}" \
      up -d --remove-orphans --wait --wait-timeout 180
}

rollback_previous() {
  if [[ -z "${PREVIOUS_RELEASE}" \
        || ! -f "${PREVIOUS_RELEASE}/compose.yaml" \
        || ! -f "${PREVIOUS_RELEASE}/release.env" ]]; then
    echo "No previous release is available for rollback." >&2
    return 1
  fi

  echo "Rolling back to ${PREVIOUS_RELEASE}"

  deploy_release "${PREVIOUS_RELEASE}"
  ln -sfn "${PREVIOUS_RELEASE}" "${CURRENT_LINK}"
}

if ! deploy_release "${RELEASE_DIR}"; then
  echo "Deployment failed." >&2
  rollback_previous || true
  exit 1
fi

ln -sfn "${RELEASE_DIR}" "${CURRENT_LINK}"
ln -sfn "${CURRENT_LINK}/compose.yaml" "${DEPLOY_PATH}/compose.yaml"
ln -sfn "${CURRENT_LINK}/release.env" "${DEPLOY_PATH}/release.env"
ln -sfn "${CURRENT_LINK}/backend.env" "${DEPLOY_PATH}/backend.env"

compose_for "${RELEASE_DIR}" ps

echo "Deployment completed: ${RELEASE_SHA}"
