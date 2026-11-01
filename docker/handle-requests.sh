#!/usr/bin/env bash
# Carries out the requests left by the administration page in docker/state/
# (run as root by owncoffer-request.path as soon as a request appears).
# Only fixed actions are possible, whatever the files contain:
#   request-backup   a manual backup (at most one every 10 minutes)
#   request-restore-test  check that the newest backup restores (at most
#                    one every 10 minutes)
#   request-check    look for a new version now
#   request-update   install the published version vX.Y.Z written in it
set -euo pipefail
cd "$(dirname "$0")/.."

log() { echo "[owncoffer-request] $*"; }
state=docker/state

if [[ -e $state/request-backup ]]; then
  # Removed first: the path unit fires again while the file exists.
  rm -f "$state/request-backup"
  last=$({ ls -1t docker/backups/owncoffer-*-manual.dump \
    docker/backups/owncoffer-*-manual.dump.gpg 2>/dev/null || true; } | head -1)
  if [[ -n $last && $(($(date +%s) - $(stat -c %Y "$last"))) -lt 600 ]]; then
    log "manual backup refused: the last one is less than 10 minutes old"
  else
    log "manual backup requested from the administration page"
    docker/backup.sh manual >/dev/null || log "manual backup failed"
  fi
fi

if [[ -e $state/request-restore-test ]]; then
  rm -f "$state/request-restore-test"
  if [[ -f $state/restore-test &&
    $(($(date +%s) - $(stat -c %Y "$state/restore-test"))) -lt 600 ]]; then
    log "restore test refused: the last one is less than 10 minutes old"
  else
    log "restore test requested from the administration page"
    docker/restore-test.sh || log "restore test failed"
  fi
fi

if [[ -e $state/request-check ]]; then
  rm -f "$state/request-check"
  log "check for a new version requested from the administration page"
  docker/auto-update.sh --check || log "check failed"
fi

if [[ -e $state/request-update ]]; then
  # Only the first line, and only if it is a version: nothing else is used.
  wanted=$(head -c 40 "$state/request-update" | head -n 1 | tr -d '[:space:]')
  rm -f "$state/request-update"
  if [[ $wanted =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    log "installation of $wanted requested from the administration page"
    docker/auto-update.sh --install "$wanted" || log "installation failed"
  else
    log "update request ignored: not a version"
  fi
fi
