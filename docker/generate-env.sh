#!/usr/bin/env sh
# Creates docker/.env from .env.example with random secrets. Never overwrites.
set -eu
cd "$(dirname "$0")"
if [ -f .env ]; then
  echo "docker/.env already exists: nothing changed." >&2
  exit 1
fi
secret() { openssl rand -base64 32 | tr -d '\n/+=' | cut -c1-40; }
umask 077
sed \
  -e "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=$(secret)|" \
  -e "s|^OWNCOFFER_SERVICE_SECRET=.*|OWNCOFFER_SERVICE_SECRET=$(secret)|" \
  -e "s|^OWNCOFFER_EMAIL_PEPPER=.*|OWNCOFFER_EMAIL_PEPPER=$(secret)|" \
  -e "s|^OWNCOFFER_JWT_KEY=.*|OWNCOFFER_JWT_KEY=$(secret)|" \
  -e "s|^OWNCOFFER_JWT_REFRESH_PEPPER=.*|OWNCOFFER_JWT_REFRESH_PEPPER=$(secret)|" \
  .env.example > .env
echo "Created docker/.env (readable by you only). Set OWNCOFFER_PUBLIC_URL, then:"
echo "  docker compose -f docker/compose.yaml up -d"
