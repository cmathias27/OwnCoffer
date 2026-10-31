#!/usr/bin/env bash
# Backs up the OwnCoffer database to docker/backups/ (pg_dump, custom format).
# Usage: docker/backup.sh [label]   — label: daily, manual, before-X.Y.Z…
# Keeps the 30 most recent nightly backups and the 10 most recent of each
# other kind, so manual backups never push the nightly ones out.
# The files hold bank data: the folder is readable by its owner only.
# The list of backups (names, sizes, dates: no data) and the result of the
# last one are written to docker/state/ for the administration page.
set -euo pipefail
cd "$(dirname "$0")"

label=${1:-manual}
if [[ ! $label =~ ^[a-z0-9.-]{1,40}$ ]]; then
  echo "backup failed: invalid label" >&2
  exit 1
fi

# The state folder is shared with the container (see install-auto-update.sh).
state=state
write_state() {
  [[ -d $state ]] || return 0
  # Name, size in bytes and date (seconds) of each backup, newest first.
  local list
  list=$(mktemp "$state/.backups.XXXXXX")
  for f in $(ls -1t backups/owncoffer-*.dump 2>/dev/null); do
    printf '%s\t%s\t%s\n' "$(basename "$f")" "$(stat -c %s "$f")" \
      "$(stat -c %Y "$f")" >> "$list"
  done
  chmod 644 "$list"
  mv "$list" "$state/backups.tsv"
  local last
  last=$(mktemp "$state/.backup-last.XXXXXX")
  printf 'at=%s\nlabel=%s\nok=%s\nmessage=%s\n' "$(date +%s)" "$label" "$1" \
    "${2:-}" > "$last"
  chmod 644 "$last"
  mv "$last" "$state/backup-last"
}
mkdir -p backups
chmod 700 backups
umask 077
file="backups/owncoffer-$(date +%Y%m%d-%H%M%S)-${label}.dump"
trap 'rm -f "$file.part"; write_state false "backup failed"' ERR

docker compose -f compose.yaml exec -T postgres \
  pg_dump -U owncoffer -d owncoffer --format=custom > "$file.part"
# A dump smaller than a few KB means the database was not dumped.
if [ "$(stat -c %s "$file.part")" -lt 2048 ]; then
  rm -f "$file.part"
  echo "backup failed: empty dump" >&2
  trap - ERR
  write_state false "empty dump"
  exit 1
fi
mv "$file.part" "$file"

keep() { # pattern, count
  { ls -1t backups/owncoffer-*-"$1".dump 2>/dev/null || true; } |
    tail -n +$(($2 + 1)) | xargs -r rm -f
}
keep daily 30
keep manual 10
keep 'before-*' 10

trap - ERR
write_state true ""
# Absolute path: callers may run from another directory.
echo "$(pwd)/$file"
