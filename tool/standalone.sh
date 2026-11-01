#!/usr/bin/env bash
# The standalone version (decision 0022) runs the same server on SQLite.
# Serverpod allows one database kind per project, so this script swaps the
# server's run-mode configs and migrations for SQLite ones, does its job,
# then puts everything back, whatever happens.
#
#   tool/standalone.sh migrations   regenerates server/standalone/migrations
#                                   (a new version only if the schema
#                                   changed) and the Dart copy shipped in
#                                   the apps (server/lib/src/standalone/
#                                   sqlite_migrations.g.dart)
#   tool/standalone.sh test [args]  runs the server tests on SQLite
#
# The CI runs both and fails if the migrations are not up to date.
set -euo pipefail
cd "$(dirname "$0")/../server"

mode=${1:-}
[[ $mode == migrations || $mode == test ]] || {
  echo "usage: tool/standalone.sh migrations|test [dart test args]" >&2
  exit 2
}
shift

backup=$(mktemp -d)
restore() {
  rm -rf migrations
  mv "$backup/migrations" migrations
  for f in development test production; do
    mv "$backup/$f.yaml" "config/$f.yaml"
  done
  rm -f owncoffer_sqlite_*.db owncoffer_sqlite_*.db-*
  rmdir "$backup"
}
mv migrations "$backup/migrations"
for f in development test production; do cp "config/$f.yaml" "$backup/$f.yaml"; done
trap restore EXIT

# Same configs, with the database section replaced by a SQLite file.
for f in development test production; do
  awk -v db="owncoffer_sqlite_$f.db" '
    /^database:/ { print "database:\n  dialect: sqlite\n  filePath: " db; skip = 1; next }
    skip && /^[^ #]/ { skip = 0 }
    !skip { print }
  ' "$backup/$f.yaml" > "config/$f.yaml"
done
mkdir -p standalone/migrations
cp -r standalone/migrations migrations

case $mode in
  migrations)
    serverpod create-migration
    rm -rf standalone/migrations
    cp -r migrations standalone/migrations
    dart run tool/embed_migrations.dart standalone/migrations \
      lib/src/standalone/sqlite_migrations.g.dart
    dart format lib/src/standalone/sqlite_migrations.g.dart >/dev/null
    ;;
  test)
    dart test "$@"
    ;;
esac
