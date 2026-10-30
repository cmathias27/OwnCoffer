#!/usr/bin/env sh
# Runs the same checks as the CI (.github/workflows/ci.yml) before pushing.
# Needs the test database: ./tool/setup_dev.sh
set -eu
cd "$(dirname "$0")/.."

step() { printf '\n== %s\n' "$1"; }

step "Dépendances"
flutter pub get >/dev/null

step "Code généré à jour (serverpod generate)"
(cd server && serverpod generate >/dev/null)
git diff --exit-code --stat -- server client \
  || { echo "Le code généré a changé : committez-le."; exit 1; }

step "Formatage"
dart format --output=none --set-exit-if-changed shared server/lib server/test server/bin app/lib app/test

step "Analyse"
dart analyze --fatal-infos shared
dart analyze server client
(cd app && flutter analyze)

step "Tests du cœur"
(cd shared && dart test)

step "Tests du serveur"
(cd server && dart test)

step "Tests de l'application"
(cd app && flutter test)

printf '\nTout est vert.\n'
