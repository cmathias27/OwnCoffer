#!/usr/bin/env bash
# Checks that a backup can really be restored, without touching the live
# database: decrypts it, restores it into a throw-away PostgreSQL container
# with no network, counts what came back, then deletes that container.
# Usage: docker/restore-test.sh [backup file]   — default: the newest backup.
# Run every night after the backup (owncoffer-backup.service) and on request
# from the administration page. The result (no bank data: a file name, a
# number of tables and of operations) is written to docker/state/restore-test.
set -euo pipefail
# A file given on the command line is relative to the caller's folder.
if [[ -n ${1:-} && -e $1 ]]; then
  set -- "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
fi
cd "$(dirname "$0")"

log() { echo "[owncoffer-restore-test] $*"; }
state=state
image=${OWNCOFFER_RESTORE_TEST_IMAGE:-ghcr.io/serverpod/postgres:16}
started=$(date +%s)
file=${1:-}
if [[ -z $file ]]; then
  file=$({ ls -1t backups/owncoffer-*.dump backups/owncoffer-*.dump.gpg \
    2>/dev/null || true; } | head -1)
fi
name=owncoffer-restore-test-$$
tables=
operations=

write_state() { # ok, message
  [[ -d $state ]] || return 0
  local f
  f=$(mktemp "$state/.restore-test.XXXXXX")
  printf 'at=%s\nfile=%s\nok=%s\ntables=%s\noperations=%s\nseconds=%s\nmessage=%s\n' \
    "$(date +%s)" "$(basename "${file:-}")" "$1" "$tables" "$operations" \
    "$(($(date +%s) - started))" "${2:-}" > "$f"
  chmod 644 "$f"
  mv "$f" "$state/restore-test"
}
fail() {
  log "FAILED: $1"
  write_state false "$1"
  exit 1
}
cleanup() { docker rm -f "$name" >/dev/null 2>&1 || true; }
trap cleanup EXIT

[[ -n $file ]] || fail "no backup to test"
[[ -s $file ]] || fail "backup not found"
log "testing $(basename "$file")"

docker run -d --rm --name "$name" --network none \
  -e POSTGRES_PASSWORD="$(head -c 24 /dev/urandom | base64 | tr -d '/+=')" \
  -e POSTGRES_DB=restore_test "$image" >/dev/null ||
  fail "could not start the test database"
# The image starts PostgreSQL once to create the database, then restarts
# it: wait for the end of that first start, then for the real server.
ready=false
for _ in $(seq 1 90); do
  if docker logs "$name" 2>&1 | grep -q 'init process complete' &&
    docker exec "$name" pg_isready -U postgres -d restore_test >/dev/null 2>&1; then
    ready=true
    break
  fi
  sleep 1
done
[[ $ready == true ]] || fail "the test database did not start"

# A tampered or truncated encrypted file fails here (gpg checks integrity).
if ! ./backup-cat.sh "$file" |
  docker exec -i "$name" pg_restore -U postgres -d restore_test \
    --no-owner --exit-on-error >/dev/null; then
  fail "the backup could not be restored"
fi

sql() { docker exec "$name" psql -U postgres -d restore_test -tAc "$1"; }
tables=$(sql "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public'")
[[ $tables -gt 0 ]] || fail "no table restored"
migrations=$(sql "SELECT count(*) FROM serverpod_migrations" 2>/dev/null || echo 0)
[[ $migrations -gt 0 ]] || fail "the restored database has no migration record"
operations=$(sql "SELECT count(*) FROM transactions" 2>/dev/null || echo 0)

log "ok: $tables tables, $operations operations, in $(($(date +%s) - started)) s"
write_state true ""
