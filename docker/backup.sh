#!/usr/bin/env bash
# Backs up the OwnCoffer database to docker/backups/ (pg_dump, custom format).
# Usage: docker/backup.sh [label]   — keeps the 30 most recent backups.
# The files hold bank data: the folder is readable by its owner only.
set -euo pipefail
cd "$(dirname "$0")"

label=${1:-manual}
mkdir -p backups
chmod 700 backups
umask 077
file="backups/owncoffer-$(date +%Y%m%d-%H%M%S)-${label}.dump"

docker compose -f compose.yaml exec -T postgres \
  pg_dump -U owncoffer -d owncoffer --format=custom > "$file.part"
# A dump smaller than a few KB means the database was not dumped.
if [ "$(stat -c %s "$file.part")" -lt 2048 ]; then
  rm -f "$file.part"
  echo "backup failed: empty dump" >&2
  exit 1
fi
mv "$file.part" "$file"

ls -1t backups/owncoffer-*.dump | tail -n +31 | xargs -r rm -f
# Absolute path: callers may run from another directory.
echo "$(pwd)/$file"
