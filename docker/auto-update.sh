#!/usr/bin/env bash
# Installs new published versions of OwnCoffer (tags vX.Y.Z), never the
# development image. The installation must be a git clone checked out at a
# version tag, as in docs/INSTALLATION.md.
#
#   docker/auto-update.sh                  every 15 minutes (owncoffer-update
#                                          .timer): checks, and installs the
#                                          newest version unless automatic
#                                          updates are off
#   docker/auto-update.sh --check          checks only (administration page)
#   docker/auto-update.sh --install vX.Y.Z installs that published version
#                                          (administration page), even with
#                                          automatic updates off
#
# For a new version: wait until its image is published, back up the
# database, switch the files and the image, restart, check the API answers.
# If it does not, go back to the previous version and restore the backup.
#
# What it finds and does is written to docker/state/ for the administration
# page (versions, release notes, history: never bank data); the page's
# choice "automatic updates off" is read from docker/state/settings.
set -euo pipefail

# git checkout replaces this file while it runs: run from a copy.
if [[ -z ${OWNCOFFER_UPDATE_DIR:-} ]]; then
  OWNCOFFER_UPDATE_DIR=$(cd "$(dirname "$0")/.." && pwd)
  export OWNCOFFER_UPDATE_DIR
  copy=$(mktemp /tmp/owncoffer-update.XXXXXX)
  cp "$0" "$copy"
  exec bash "$copy" "$@"
fi
trap 'rm -f "$0"' EXIT
cd "$OWNCOFFER_UPDATE_DIR"

log() { echo "[owncoffer-update] $*"; }
compose() { docker compose -f docker/compose.yaml "$@"; }

mode=auto
wanted=
case ${1:-} in
  "") ;;
  --check) mode=check ;;
  --install)
    mode=install
    wanted=${2:-}
    if [[ ! $wanted =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      log "--install needs a version vX.Y.Z"
      exit 2
    fi
    ;;
  *)
    log "unknown option $1"
    exit 2
    ;;
esac

# One run at a time (timer and administration page).
mkdir -p docker/backups
exec 9> docker/backups/.update.lock
if ! flock -n 9; then
  log "another update is running: nothing done"
  exit 0
fi

# Installations made before the administration page (0.3.8) lack the
# request unit and the shared folder: add them once (we run as root).
# Those made before 1.0 lack the nightly restore test: rewrite the units.
if [[ $(id -u) == 0 ]] && { [[ ! -f /etc/systemd/system/owncoffer-request.path ]] ||
  ! grep -q restore-test /etc/systemd/system/owncoffer-backup.service 2>/dev/null; }; then
  log "installing the units of the administration page"
  docker/install-auto-update.sh --quiet || log "could not install them"
fi

state=docker/state

# Free space of the disk holding OwnCoffer, for the health page.
write_disk() {
  [[ -d $state ]] || return 0
  local f
  f=$(mktemp "$state/.disk.XXXXXX")
  df -Pk . | awk 'NR == 2 { printf "total=%.0f\nfree=%.0f\n", $2 * 1024, $4 * 1024 }' > "$f"
  printf 'at=%s\n' "$(date +%s)" >> "$f"
  chmod 644 "$f"
  mv "$f" "$state/disk"
}
write_disk || true

auto=true
if [[ -f $state/settings ]] && grep -qx 'auto=false' "$state/settings"; then
  auto=false
fi

current="v$(sed -n 's/^OWNCOFFER_TAG=//p' docker/.env)"
latest=
message=

# key=value file read by the administration page.
write_status() {
  [[ -d $state ]] || return 0
  local f
  f=$(mktemp "$state/.update-status.XXXXXX")
  printf 'current=%s\nlatest=%s\nchecked=%s\nauto=%s\nfailed=%s\nmessage=%s\n' \
    "$current" "$latest" "$(date +%s)" "$auto" \
    "$(cat docker/backups/failed-version 2>/dev/null || true)" "$message" > "$f"
  chmod 644 "$f"
  mv "$f" "$state/update-status"
}
# One line per attempt: date, from, to, result (installed, rollback,
# rollback-failed, refused), message.
record() {
  [[ -d $state ]] || return 0
  printf '%s\t%s\t%s\t%s\t%s\n' "$(date +%s)" "$current" "$1" "$2" "${3:-}" \
    >> "$state/update-history.tsv"
  chmod 644 "$state/update-history.tsv"
  tail -n 50 "$state/update-history.tsv" > "$state/.history" &&
    chmod 644 "$state/.history" && mv "$state/.history" "$state/update-history.tsv"
}
# Step of an installation, shown by the administration page while it runs:
# pull, backup, start, check, done, rollback, failed or waiting (image not
# published yet).
progress() {
  [[ -d $state && $mode != check ]] || return 0
  local f
  f=$(mktemp "$state/.update-progress.XXXXXX")
  printf 'target=%s\nstep=%s\nat=%s\n' "${target:-$wanted}" "$1" "$(date +%s)" > "$f"
  chmod 644 "$f"
  mv "$f" "$state/update-progress"
}
stop() { # message, exit code
  message=$1
  [[ -z $1 ]] || log "$1"
  write_status
  exit "$2"
}

# The installed version is the image tag in docker/.env (this script keeps
# it in step with the files); "edge" or a custom tag is never touched.
if [[ ! $current =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  stop "OWNCOFFER_TAG is not a version (${current#v}): nothing done" 1
fi
if ! git diff --quiet || ! git diff --cached --quiet; then
  stop "files changed by hand in $(pwd): nothing done (git status to see them)" 1
fi

git fetch --quiet --tags --prune-tags origin
latest=$(git tag -l 'v[0-9]*.[0-9]*.[0-9]*' | sort -V | tail -1)
# Release notes of the newest version (they list every version before it).
if [[ -d $state && -n $latest ]]; then
  if git show "$latest:CHANGELOG.md" > "$state/.changelog" 2>/dev/null; then
    chmod 644 "$state/.changelog"
    mv "$state/.changelog" "$state/CHANGELOG.md"
  else
    rm -f "$state/.changelog"
  fi
fi

target=$latest
if [[ $mode == install ]]; then
  if ! git rev-parse -q --verify "refs/tags/$wanted" >/dev/null; then
    record "$wanted" refused "not a published version"
    progress failed
    stop "$wanted is not a published version: nothing done" 1
  fi
  target=$wanted
fi
newest=$(printf '%s\n%s\n' "$current" "$target" | sort -V | tail -1)
if [[ $target == "$current" || $newest == "$current" ]]; then
  if [[ $mode == install ]]; then
    record "$target" refused "not newer than $current"
    progress failed
  fi
  stop "" 0
fi
if [[ $mode == check ]]; then
  stop "" 0
fi
if [[ $mode == auto && $auto == false ]]; then
  stop "automatic updates are off: $target waits to be installed" 0
fi
version=${target#v}

# A version that failed once is not retried automatically (it would stop
# the service at every run); the next published version will be tried. The
# administration page may still ask for it.
failed_file=docker/backups/failed-version
if [[ $mode == auto && -f $failed_file && $(cat "$failed_file") == "$target" ]]; then
  stop "$target failed before: waiting for the next version" 0
fi

image=$(sed -n 's/^OWNCOFFER_IMAGE=//p' docker/.env)
image=${image:-ghcr.io/cmathias27/owncoffer}

# The image is built by the CI a few minutes after the tag: retry later.
progress pull
if ! docker pull --quiet "$image:$version" >/dev/null 2>&1; then
  progress waiting
  stop "$target: image not published yet, next try in 15 minutes" 0
fi

port=$(sed -n 's/^OWNCOFFER_PORT=//p' docker/.env)
port=${port:-8080}
healthy() {
  # About 3 minutes (OWNCOFFER_HEALTH_TRIES: tests).
  for _ in $(seq 1 "${OWNCOFFER_HEALTH_TRIES:-36}"); do
    if [[ $(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:$port/api/") == 200 ]]; then
      return 0
    fi
    sleep 5
  done
  return 1
}
set_tag() { sed -i "s/^OWNCOFFER_TAG=.*/OWNCOFFER_TAG=$1/" docker/.env; }

log "$current -> $target: backup"
progress backup
dump=$(docker/backup.sh "before-$version")
log "backup: $dump"
# The rollback restores this file: it must be readable before going on.
if [[ ! -s $dump ]]; then
  record "$target" refused "backup not found"
  progress failed
  stop "backup not found ($dump): nothing changed" 1
fi

git -c advice.detachedHead=false checkout --quiet "$target"
set_tag "$version"
log "starting $target"
progress start
compose up -d --remove-orphans --quiet-pull
progress check
if healthy; then
  log "$target installed"
  record "$target" installed ""
  rm -f "$failed_file"
  progress done
  current=$target
  message=""
  write_status
  exit 0
fi

log "$target does not answer: back to $current and to the backup"
progress rollback
echo "$target" > "$failed_file"
compose logs --tail 80 owncoffer >&2 || true
git -c advice.detachedHead=false checkout --quiet "$current"
set_tag "${current#v}"
if [[ ! -s $dump ]]; then
  record "$target" rollback-failed "backup missing"
  progress failed
  stop "ROLLBACK STOPPED: backup $dump missing; database left as is" 1
fi
compose stop owncoffer
compose up -d postgres
# Empty schema first: tables added by the failed version must not remain.
compose exec -T postgres psql -q -U owncoffer -d owncoffer \
  -c 'DROP SCHEMA public CASCADE; CREATE SCHEMA public;'
# Encrypted backups (.dump.gpg) are decrypted on the fly; the key stays in
# docker/backup.key, which git never touches.
if [[ $dump == *.gpg ]]; then
  gpg --batch --quiet --pinentry-mode loopback --decrypt \
    --passphrase-file docker/backup.key "$dump"
else
  cat "$dump"
fi | compose exec -T postgres \
  pg_restore -U owncoffer -d owncoffer --no-owner
compose up -d --remove-orphans
if healthy; then
  record "$target" rollback "$target did not answer; back on $current"
  progress failed
  stop "back on $current with the data of $dump" 1
fi
record "$target" rollback-failed "$current does not answer either"
progress failed
stop "ROLLBACK FAILED: $current does not answer either; backup kept in $dump" 1
