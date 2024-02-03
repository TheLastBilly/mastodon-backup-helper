#!/bin/bash

DEFAULT_DATA_VIEWER_PORT=8080
DEFAULT_DATA_VIEWER_HOST=localhost

if [[ -z "$BACKUP_PATH" ]]; then
    BACKUP_PATH="./"
fi

if [[ -z "$DATA_VIEWER_PORT" ]]; then
    printf "Web server port (default=$DEFAULT_DATA_VIEWER_PORT): "
    read DATA_VIEWER_PORT
    if [[ -z "$DATA_VIEWER_PORT" ]]; then
        DATA_VIEWER_PORT=8080
    fi
fi
export DATA_VIEWER_PORT

if [[ -z "$DATA_VIEWER_HOST" ]]; then
    printf "Web server host (default=$DEFAULT_DATA_VIEWER_HOST): "
    read DATA_VIEWER_HOST
    if [[ -z "$DATA_VIEWER_HOST" ]]; then
        DATA_VIEWER_HOST="localhost"
    fi
fi
export DATA_VIEWER_HOST

while [[ -z "$MASTODON_USER" ]]; do
    printf "What's your mastodon username? (include the domain, i.e: user@domain.tld) (no default): "
    read MASTODON_USER
done
export MASTODON_USER

BACKUP_PATH=$(realpath "$BACKUP_PATH")

cd "$BACKUP_PATH"
git clone https://github.com/TheLastBilly/mastodon-backup-helper 
cd mastodon-backup-helper
./setup.sh

SYSTEMD_USER_PATH="$HOME/.config/systemd/user"
if [ ! -d $SYSTEMD_USER_PATH ]; then
    echo "Cannot find \"$SYSTEMD_USER_PATH\", is systemd installed?"
    exit 1
fi

SERVICE_NAME="mastodon-backup-helper.service"
cat > "$SYSTEMD_USER_PATH/$SERVICE_NAME" << EOF
[Unit]
Description=Unit service file for mastodon-backup-helper

[Service]
Type=simple
StandardOutput=journal
WorkingDirectory=$BACKUP_PATH/mastodon-backup-helper
Environment="DATA_VIEWER_PORT=$DATA_VIEWER_PORT"
Environment="DATA_VIEWER_HOST=$DATA_VIEWER_HOST"
Environment="MASTODON_USER=$MASTODON_USER"
ExecStart=$(which bash) service.sh

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable "$SERVICE_NAME"
systemctl --user restart "$SERVICE_NAME"