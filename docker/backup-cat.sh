#!/usr/bin/env bash
# Writes the plain pg_dump of a backup to standard output, decrypting it
# with docker/backup.key if it is encrypted (.dump.gpg). Used to restore:
#   docker/backup-cat.sh docker/backups/owncoffer-….dump.gpg |
#     docker compose -f docker/compose.yaml exec -T postgres \
#       pg_restore -U owncoffer -d owncoffer --clean --if-exists --no-owner
# Another key file can be given with OWNCOFFER_BACKUP_KEY (e.g. the copy
# kept outside the server, to restore on a new machine).
set -euo pipefail
file=${1:?usage: docker/backup-cat.sh <backup file>}
key=${OWNCOFFER_BACKUP_KEY:-$(cd "$(dirname "$0")" && pwd)/backup.key}
case $file in
  *.gpg)
    [[ -s $key ]] || { echo "backup key not found: $key" >&2; exit 1; }
    gpg --batch --quiet --pinentry-mode loopback --decrypt --passphrase-file "$key" "$file"
    ;;
  *) cat "$file" ;;
esac
