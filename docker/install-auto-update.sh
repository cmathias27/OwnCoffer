#!/usr/bin/env bash
# Installs the systemd units of this OwnCoffer installation (run as root):
#   owncoffer-update.timer   every 15 minutes: docker/auto-update.sh
#   owncoffer-backup.timer   every night at 03:30: docker/backup.sh daily,
#                            then docker/restore-test.sh
#   owncoffer-request.path   as soon as the administration page leaves a
#                            request in docker/state/: docker/handle-requests.sh
# Logs: journalctl -u owncoffer-update -u owncoffer-backup -u owncoffer-request
# Can be run again at any time: it only rewrites the units.
set -euo pipefail
dir=$(cd "$(dirname "$0")/.." && pwd)

# Folder shared with the container (docker/compose.yaml), writable by the
# app's user (uid 10001 in the image): requests one way, state the other.
mkdir -p "$dir/docker/state"
chown 10001:10001 "$dir/docker/state"
chmod 750 "$dir/docker/state"

cat > /etc/systemd/system/owncoffer-update.service <<EOF
[Unit]
Description=OwnCoffer: install new published versions
After=docker.service network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=$dir/docker/auto-update.sh
EOF

cat > /etc/systemd/system/owncoffer-update.timer <<EOF
[Unit]
Description=OwnCoffer: check for a new version every 15 minutes

[Timer]
OnBootSec=5min
OnUnitActiveSec=15min
Persistent=true

[Install]
WantedBy=timers.target
EOF

cat > /etc/systemd/system/owncoffer-backup.service <<EOF
[Unit]
Description=OwnCoffer: nightly database backup and restore test
After=docker.service

[Service]
Type=oneshot
ExecStart=$dir/docker/backup.sh daily
# Then checks that this backup really restores (throw-away container).
ExecStart=$dir/docker/restore-test.sh
EOF

cat > /etc/systemd/system/owncoffer-backup.timer <<EOF
[Unit]
Description=OwnCoffer: nightly database backup

[Timer]
OnCalendar=*-*-* 03:30:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

cat > /etc/systemd/system/owncoffer-request.service <<EOF
[Unit]
Description=OwnCoffer: requests from the administration page
After=docker.service

[Service]
Type=oneshot
ExecStart=$dir/docker/handle-requests.sh
EOF

cat > /etc/systemd/system/owncoffer-request.path <<EOF
[Unit]
Description=OwnCoffer: watch the administration page's requests

[Path]
PathExistsGlob=$dir/docker/state/request-*
Unit=owncoffer-request.service

[Install]
WantedBy=paths.target
EOF

systemctl daemon-reload
systemctl enable --now owncoffer-update.timer owncoffer-backup.timer \
  owncoffer-request.path
if [[ ${1:-} != --quiet ]]; then
  systemctl list-timers 'owncoffer-*' --no-pager
fi
