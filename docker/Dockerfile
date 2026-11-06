# OwnCoffer image: Serverpod server + Flutter web app.
# Build from the repository root:
#   docker build -f docker/Dockerfile -t owncoffer .

ARG DART_VERSION=3.13.7
ARG FLUTTER_VERSION=3.47.9

# --- Flutter web app ----------------------------------------------------------
FROM dart:${DART_VERSION} AS web
ARG FLUTTER_VERSION
RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends git unzip xz-utils ca-certificates >/dev/null \
 && git clone -q --depth 1 -b ${FLUTTER_VERSION} https://github.com/flutter/flutter.git /opt/flutter
ENV PATH="/opt/flutter/bin:${PATH}"
RUN flutter config --no-analytics >/dev/null && flutter precache --web >/dev/null
WORKDIR /src
COPY pubspec.yaml pubspec.lock ./
COPY shared/pubspec.yaml shared/
COPY client/pubspec.yaml client/
COPY server/pubspec.yaml server/
COPY app/pubspec.yaml app/
RUN flutter pub get
COPY . .
RUN cd app && flutter build web --release --base-href / --no-web-resources-cdn

# --- Server -------------------------------------------------------------------
FROM dart:${DART_VERSION} AS server
WORKDIR /src
COPY pubspec.lock .
COPY shared shared
COPY client client
COPY server server
# Minimal workspace without the Flutter app, keeping the locked versions.
RUN printf '%s\n' 'name: _' 'environment:' '  sdk: ^3.12.2' 'workspace:' \
      '  - shared' '  - client' '  - server' > pubspec.yaml \
 && dart pub get
WORKDIR /src/server
RUN dart build cli --target bin/main.dart --output build \
 && mv build/bundle/bin/main build/bundle/bin/server \
 && mkdir -p config web migrations

# --- GeoIP database (decision 0027) -----------------------------------------
# DB-IP Lite City (CC BY 4.0, IP Geolocation by DB-IP, https://db-ip.com),
# fetched while the image is built: the server finds the city of a session
# in this file, never online. The month of the CI build refreshes it at each
# version; the month before is tried when the new one is not out yet.
# GEOIP_MONTH=none builds without it (every place unknown).
FROM alpine:3.24 AS geoip
ARG GEOIP_MONTH=
WORKDIR /geoip
RUN set -eu; \
    [ "$GEOIP_MONTH" = none ] && exit 0; \
    month="${GEOIP_MONTH:-$(date -u +%Y-%m)}"; \
    before="$(date -u -d "@$(( $(date -u -d "${month}-01" +%s) - 86400 ))" +%Y-%m)"; \
    for m in "$month" "$before"; do \
      if wget -q -O city.mmdb.gz "https://download.db-ip.com/free/dbip-city-lite-${m}.mmdb.gz"; then \
        break; \
      fi; \
      rm -f city.mmdb.gz; \
    done; \
    [ -s city.mmdb.gz ] || { echo "DB-IP Lite City introuvable" >&2; exit 1; }; \
    gunzip -c city.mmdb.gz > dbip-city-lite.mmdb; rm city.mmdb.gz; \
    tail -c 131072 dbip-city-lite.mmdb | tr -c 'A-Za-z.' '\n' | grep -qx 'MaxMind.com' \
      || { echo "Base GeoIP illisible" >&2; exit 1; }; \
    printf '%s\n' "IP Geolocation by DB-IP (https://db-ip.com), ${m}." \
      'Licence : Creative Commons Attribution 4.0 International.' \
      'https://creativecommons.org/licenses/by/4.0/' > LISEZMOI.txt

# --- Runtime ------------------------------------------------------------------
FROM alpine:3.24
# Fixed ids: the host gives this user the shared docker/state folder.
RUN addgroup -S -g 10001 owncoffer && adduser -S -u 10001 -G owncoffer owncoffer
WORKDIR /app
COPY --from=server /runtime/ /
COPY --from=server /src/server/build/bundle/ ./
COPY --from=server /src/server/config/ config/
COPY --from=server /src/server/migrations/ migrations/
COPY --from=server /src/server/web/ web/
COPY --from=server /src/server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml
COPY --from=web /src/app/build/web/ web/app/
COPY --from=geoip /geoip/ geoip/
COPY LICENSE LICENSE-EXCEPTION.md ./
RUN rm -f config/passwords.yaml && chown -R owncoffer:owncoffer /app
USER owncoffer

ENV runmode=production \
    serverid=default \
    logging=normal \
    role=monolith \
    OWNCOFFER_API_PATH=/api/

# 8080 API, 8082 web app — reachable only on the private Docker network.
EXPOSE 8080 8082
ENTRYPOINT ["/bin/sh", "-c", "exec ./bin/server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role --apply-migrations"]
