#!/usr/bin/env bash
# Installs two systemd timers for this OwnCoffer installation (run as root):
#   owncoffer-update.timer  every 15 minutes: docker/auto-update.sh
#   owncoffer-backup.timer  every night at 03:30: docker/backup.sh daily
# Logs: journalctl -u owncoffer-update -u owncoffer-backup
set -euo pipefail
dir=$(cd "$(dirname "$0")/.." && pwd)

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
Description=OwnCoffer: nightly database backup
After=docker.service

[Service]
Type=oneshot
ExecStart=$dir/docker/backup.sh daily
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

systemctl daemon-reload
systemctl enable --now owncoffer-update.timer owncoffer-backup.timer
systemctl list-timers 'owncoffer-*' --no-pager
