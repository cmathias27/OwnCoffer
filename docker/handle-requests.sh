#!/usr/bin/env bash
# Carries out the requests left by the administration page in docker/state/
# (run as root by owncoffer-request.path as soon as a request appears).
# Only fixed actions are possible, whatever the files contain:
#   request-backup   a manual backup (at most one every 10 minutes)
set -euo pipefail
cd "$(dirname "$0")/.."

log() { echo "[owncoffer-request] $*"; }
state=docker/state

if [[ -e $state/request-backup ]]; then
  # Removed first: the path unit fires again while the file exists.
  rm -f "$state/request-backup"
  last=$({ ls -1t docker/backups/owncoffer-*-manual.dump 2>/dev/null ||
    true; } | head -1)
  if [[ -n $last && $(($(date +%s) - $(stat -c %Y "$last"))) -lt 600 ]]; then
    log "manual backup refused: the last one is less than 10 minutes old"
  else
    log "manual backup requested from the administration page"
    docker/backup.sh manual >/dev/null || log "manual backup failed"
  fi
fi
