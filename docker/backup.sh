#!/usr/bin/env bash
# Backs up the OwnCoffer database to docker/backups/ (pg_dump, custom format),
# encrypted with docker/backup.key (decision 0019).
# Usage: docker/backup.sh [label]   — label: daily, manual, before-X.Y.Z…
# Keeps the 30 most recent nightly backups and the 10 most recent of each
# other kind, so manual backups never push the nightly ones out.
#
# Encryption: gpg, AES-256, symmetric, with the passphrase in
# docker/backup.key (created on the first run, readable by its owner only).
# Without that key the backups cannot be read: keep a copy elsewhere.
# OWNCOFFER_BACKUP_ENCRYPT=false in docker/.env turns it off. If gpg is
# missing the backup is still made, unencrypted, and the administration page
# says so: a backup before an update must never be skipped.
#
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
write_state() { # ok, message, encrypted
  [[ -d $state ]] || return 0
  # Name, size in bytes and date (seconds) of each backup, newest first.
  local list
  list=$(mktemp "$state/.backups.XXXXXX")
  for f in $(ls -1t backups/owncoffer-*.dump backups/owncoffer-*.dump.gpg \
    2>/dev/null); do
    printf '%s\t%s\t%s\n' "$(basename "$f")" "$(stat -c %s "$f")" \
      "$(stat -c %Y "$f")" >> "$list"
  done
  chmod 644 "$list"
  mv "$list" "$state/backups.tsv"
  local last
  last=$(mktemp "$state/.backup-last.XXXXXX")
  printf 'at=%s\nlabel=%s\nok=%s\nmessage=%s\nencrypted=%s\n' "$(date +%s)" \
    "$label" "$1" "${2:-}" "${3:-}" > "$last"
  chmod 644 "$last"
  mv "$last" "$state/backup-last"
}

encrypt=true
if [[ -f .env ]] && grep -qx 'OWNCOFFER_BACKUP_ENCRYPT=false' .env; then
  encrypt=false
fi
warning=
if [[ $encrypt == true ]] && ! command -v gpg >/dev/null; then
  encrypt=false
  warning="not encrypted: gpg missing (apt install gnupg)"
  echo "backup: $warning" >&2
fi

mkdir -p backups
chmod 700 backups
umask 077
if [[ $encrypt == true && ! -s backup.key ]]; then
  # 48 random bytes, base64: the passphrase of every backup from now on.
  head -c 48 /dev/urandom | base64 -w0 > backup.key
  echo "backup: created docker/backup.key — keep a copy outside this server" >&2
fi

file="backups/owncoffer-$(date +%Y%m%d-%H%M%S)-${label}.dump"
[[ $encrypt == true ]] && file="$file.gpg"
trap 'rm -f "$file.part"; write_state false "backup failed" "$encrypt"' ERR

dump() {
  docker compose -f compose.yaml exec -T postgres \
    pg_dump -U owncoffer -d owncoffer --format=custom
}
if [[ $encrypt == true ]]; then
  # pg_dump's custom format is already compressed.
  dump | gpg --batch --quiet --pinentry-mode loopback --yes --symmetric --cipher-algo AES256 \
    --compress-algo none --passphrase-file backup.key \
    --output "$file.part"
else
  dump > "$file.part"
fi
# A dump smaller than a few KB means the database was not dumped.
if [ "$(stat -c %s "$file.part")" -lt 2048 ]; then
  rm -f "$file.part"
  echo "backup failed: empty dump" >&2
  trap - ERR
  write_state false "empty dump" "$encrypt"
  exit 1
fi
mv "$file.part" "$file"

keep() { # label pattern, count
  { ls -1t backups/owncoffer-*-"$1".dump backups/owncoffer-*-"$1".dump.gpg \
    2>/dev/null || true; } | tail -n +$(($2 + 1)) | xargs -r rm -f
}
keep daily 30
keep manual 10
keep 'before-*' 10

trap - ERR
write_state true "$warning" "$encrypt"
# Absolute path: callers may run from another directory.
echo "$(pwd)/$file"
