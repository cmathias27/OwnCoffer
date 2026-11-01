#!/usr/bin/env bash
# End-to-end test of the backups (CI job "Sauvegardes", decision 0019):
# a throw-away PostgreSQL started with docker compose under its own project
# name, filled with fictitious data, backed up encrypted, then restored by
# docker/restore-test.sh, by hand, and after tampering (must fail).
# Never run it on a real installation: it refuses if docker/.env exists.
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -e docker/.env ]]; then
  echo "docker/.env exists: this looks like a real installation, nothing done." >&2
  exit 1
fi
export COMPOSE_PROJECT_NAME=owncoffer-backup-test
compose() { docker compose -f docker/compose.yaml "$@"; }
step() { printf '\n== %s\n' "$1"; }
fail() { echo "FAILED: $*" >&2; exit 1; }

cleanup() {
  compose down -v --remove-orphans >/dev/null 2>&1 || true
  rm -rf docker/.env docker/backups docker/state docker/backup.key
}
trap cleanup EXIT

step "Base de test"
docker/generate-env.sh >/dev/null
mkdir -p docker/state
compose up -d --wait postgres
psql() { compose exec -T postgres psql -v ON_ERROR_STOP=1 -q -U owncoffer -d owncoffer "$@"; }
migration=$(ls -d server/migrations/2*/ | sort | tail -1)
psql < "$migration/definition.sql" >/dev/null
psql <<'SQL'
INSERT INTO "groups" ("id", "name", "createdBy")
  VALUES (1, 'Foyer test', '00000000-0000-0000-0000-000000000001');
INSERT INTO "accounts" ("id", "groupId", "name", "kind")
  VALUES (1, 1, 'Compte test', 'checking');
INSERT INTO "transactions"
  ("accountId", "date", "amountCents", "rawLabel", "cleanLabel", "operationKind")
SELECT 1, DATE '2026-01-01' + (i % 300), -100 * i,
  'PRLV OWNCOFFER-TEST-LABEL ' || i, 'OWNCOFFER-TEST-LABEL', 'directDebit'
FROM generate_series(1, 500) AS i;
SQL
count() { psql -tAc 'SELECT count(*) FROM transactions' | tr -d '[:space:]'; }
[[ $(count) == 500 ]] || fail "test data not inserted"

step "Sauvegarde chiffrée"
file=$(docker/backup.sh manual)
[[ $file == *.dump.gpg && -s $file ]] || fail "no encrypted backup: $file"
[[ -s docker/backup.key ]] || fail "backup key not created"
[[ $(stat -c %a docker/backup.key) == 600 ]] || fail "backup key readable by others"
[[ $(stat -c %a docker/backups) == 700 ]] || fail "backups folder readable by others"
if grep -aq OWNCOFFER-TEST-LABEL "$file"; then fail "backup readable without the key"; fi
grep -qx 'ok=true' docker/state/backup-last || fail "backup-last not ok"
grep -qx 'encrypted=true' docker/state/backup-last || fail "backup-last: not encrypted"
grep -q "$(basename "$file")" docker/state/backups.tsv || fail "backup not listed"

step "Test de restauration automatique"
docker/restore-test.sh
grep -qx 'ok=true' docker/state/restore-test || fail "restore test not ok"
grep -qx 'operations=500' docker/state/restore-test || fail "operations not restored"

step "Sauvegarde modifiée : refusée"
cp "$file" /tmp/owncoffer-tampered.dump.gpg
size=$(stat -c %s /tmp/owncoffer-tampered.dump.gpg)
printf 'X' | dd of=/tmp/owncoffer-tampered.dump.gpg bs=1 seek=$((size / 2)) \
  conv=notrunc status=none
if docker/restore-test.sh /tmp/owncoffer-tampered.dump.gpg; then
  fail "a tampered backup was accepted"
fi
grep -qx 'ok=false' docker/state/restore-test || fail "failure not recorded"
rm -f /tmp/owncoffer-tampered.dump.gpg

step "Mauvaise clé : illisible"
head -c 48 /dev/urandom | base64 -w0 > /tmp/owncoffer-wrong.key
if OWNCOFFER_BACKUP_KEY=/tmp/owncoffer-wrong.key docker/backup-cat.sh "$file" \
  > /dev/null 2>&1; then
  fail "decrypted with a wrong key"
fi
rm -f /tmp/owncoffer-wrong.key

step "Restauration réelle (comme le retour arrière d'une mise à jour)"
psql -c 'DELETE FROM transactions WHERE id > 100'
[[ $(count) == 100 ]] || fail "delete did not work"
psql -c 'SET client_min_messages = warning; DROP SCHEMA public CASCADE; CREATE SCHEMA public;'
docker/backup-cat.sh "$file" |
  compose exec -T postgres pg_restore -U owncoffer -d owncoffer --no-owner
[[ $(count) == 500 ]] || fail "restore did not bring the 500 operations back"

step "Sans chiffrement (OWNCOFFER_BACKUP_ENCRYPT=false)"
echo 'OWNCOFFER_BACKUP_ENCRYPT=false' >> docker/.env
plain=$(docker/backup.sh daily)
[[ $plain == *-daily.dump ]] || fail "unencrypted backup expected: $plain"
grep -qx 'encrypted=false' docker/state/backup-last || fail "backup-last: encrypted"
docker/restore-test.sh "$plain"
grep -qx 'operations=500' docker/state/restore-test || fail "plain restore failed"
[[ $(wc -l < docker/state/backups.tsv) == 2 ]] || fail "both backups not listed"

printf '\nSauvegardes et restauration : tout est vert.\n'
