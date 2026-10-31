#!/usr/bin/env bash
# Installs new published versions of OwnCoffer (tags vX.Y.Z), never the
# development image. Run every 15 minutes by owncoffer-update.timer
# (docker/install-auto-update.sh). The installation must be a git clone
# checked out at a version tag, as in docs/INSTALLATION.md.
#
# For a new version: wait until its image is published, back up the
# database, switch the files and the image, restart, check the API answers.
# If it does not, go back to the previous version and restore the backup.
set -euo pipefail
cd "$(dirname "$0")/.."

log() { echo "[owncoffer-update] $*"; }
compose() { docker compose -f docker/compose.yaml "$@"; }

# Installations made before the administration page (0.3.8) lack the
# request unit and the shared folder: add them once (we run as root).
if [[ $(id -u) == 0 && ! -f /etc/systemd/system/owncoffer-request.path ]]; then
  log "installing the units of the administration page"
  docker/install-auto-update.sh --quiet || log "could not install them"
fi

# The installed version is the image tag in docker/.env (this script keeps
# it in step with the files); "edge" or a custom tag is never touched.
current="v$(sed -n 's/^OWNCOFFER_TAG=//p' docker/.env)"
if [[ ! $current =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  log "OWNCOFFER_TAG is not a version (${current#v}): nothing done"
  exit 1
fi
if ! git diff --quiet || ! git diff --cached --quiet; then
  log "files changed by hand in $(pwd): nothing done (git status to see them)"
  exit 1
fi

git fetch --quiet --tags --prune-tags origin
latest=$(git tag -l 'v[0-9]*.[0-9]*.[0-9]*' | sort -V | tail -1)
newest=$(printf '%s\n%s\n' "$current" "$latest" | sort -V | tail -1)
if [[ $latest == "$current" || $newest == "$current" ]]; then
  exit 0
fi
version=${latest#v}

# A version that failed once is not retried (it would stop the service at
# every run); the next published version will be tried.
failed_file=docker/backups/failed-version
if [[ -f $failed_file && $(cat "$failed_file") == "$latest" ]]; then
  exit 0
fi

image=$(sed -n 's/^OWNCOFFER_IMAGE=//p' docker/.env)
image=${image:-ghcr.io/cmathias27/owncoffer}

# The image is built by the CI a few minutes after the tag: retry later.
if ! docker pull --quiet "$image:$version" >/dev/null 2>&1; then
  log "$latest: image not published yet, next try in 15 minutes"
  exit 0
fi

port=$(sed -n 's/^OWNCOFFER_PORT=//p' docker/.env)
port=${port:-8080}
healthy() {
  for _ in $(seq 1 36); do
    if [[ $(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:$port/api/") == 200 ]]; then
      return 0
    fi
    sleep 5
  done
  return 1
}
set_tag() { sed -i "s/^OWNCOFFER_TAG=.*/OWNCOFFER_TAG=$1/" docker/.env; }

log "$current -> $latest: backup"
dump=$(docker/backup.sh "before-$version")
log "backup: $dump"
# The rollback restores this file: it must be readable before going on.
if [[ ! -s $dump ]]; then
  log "backup not found ($dump): nothing changed"
  exit 1
fi

git -c advice.detachedHead=false checkout --quiet "$latest"
set_tag "$version"
log "starting $latest"
compose up -d --remove-orphans --quiet-pull
if healthy; then
  log "$latest installed"
  exit 0
fi

log "$latest does not answer: back to $current and to the backup"
echo "$latest" > "$failed_file"
compose logs --tail 80 owncoffer >&2 || true
git -c advice.detachedHead=false checkout --quiet "$current"
set_tag "${current#v}"
if [[ ! -s $dump ]]; then
  log "ROLLBACK STOPPED: backup $dump missing; database left as is"
  exit 1
fi
compose stop owncoffer
compose up -d postgres
# Empty schema first: tables added by the failed version must not remain.
compose exec -T postgres psql -q -U owncoffer -d owncoffer \
  -c 'DROP SCHEMA public CASCADE; CREATE SCHEMA public;'
compose exec -T postgres \
  pg_restore -U owncoffer -d owncoffer --no-owner < "$dump"
compose up -d --remove-orphans
if healthy; then
  log "back on $current with the data of $dump"
else
  log "ROLLBACK FAILED: $current does not answer either; backup kept in $dump"
fi
exit 1
