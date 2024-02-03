#!/bin/bash

DEFAULT_BACKUP_PATH="./"
DEFAULT_DATA_VIEWER_PORT=8080
DEFAULT_DATA_VIEWER_HOST=localhost

echo "WARNING: This script is still a work in progress, please take your time to review the code at https://github.com/TheLastBilly/mastodon-backup-helper if you can."

CONTINUE=""
while [[ -z "$CONTINUE" ]]; do
    printf "Would you like to continue? [yes/no] (no default): "
    read CONTINUE
    if [ "$CONTINUE" == "yes" ]; then
        break
    elif [ "$CONTINUE" == "no" ]; then
        exit 0
    fi
done

if [[ -z "$BACKUP_PATH" ]]; then
    printf "Installation path for mastodon-backup-helper (default=$DEFAULT_BACKUP_PATH): "
    read BACKUP_PATH
    if [[ -z "$BACKUP_PATH" ]]; then
        BACKUP_PATH="$DEFAULT_BACKUP_PATH"
    fi
fi
export BACKUP_PATH

if [[ -z "$DATA_VIEWER_PORT" ]]; then
    printf "Web server port (default=$DEFAULT_DATA_VIEWER_PORT): "
    read DATA_VIEWER_PORT
    if [[ -z "$DATA_VIEWER_PORT" ]]; then
        DATA_VIEWER_PORT=$DEFAULT_DATA_VIEWER_PORT
    fi
fi
export DATA_VIEWER_PORT

if [[ -z "$DATA_VIEWER_HOST" ]]; then
    printf "Web server host (default=$DEFAULT_DATA_VIEWER_HOST): "
    read DATA_VIEWER_HOST
    if [[ -z "$DATA_VIEWER_HOST" ]]; then
        DATA_VIEWER_HOST="$DEFAULT_DATA_VIEWER_HOST"
    fi
fi
export DATA_VIEWER_HOST

while [[ -z "$MASTODON_USER" ]]; do
    printf "What's your mastodon username? (include the domain, i.e: user@domain.tld) (no default): "
    read MASTODON_USER
done
export MASTODON_USER

BACKUP_PATH=$(realpath "$BACKUP_PATH")

sudo apt install -y python3 python3-virtualenv python3-pip git

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
RuntimeMaxSec=1d
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
echo "Created \"$SERVICE_NAME\""

ENABLE_LINGER="no"
LINGER_COMMAND="loginctl enable-linger"
printf "Would you like to run $SERVICE_NAME on boot ($LINGER_COMMAND)? [yes/no] (default=no): "
read ENABLE_LINGER
if [ "$ENABLE_LINGER" == "yes" ]; then
    `$LINGER_COMMAND`
fi

# UPDATE_CRONJOB_SCRIPT="systemctl --user restart $SERVICE_NAME"
# CRONTAB=$(crontab -l 2>&1)
# if [ "$CRONTAB" = "no crontab for $USER" ] | [[ "$CRONTAB" != *"$UPDATE_CRONJOB_SCRIPT"* ]] ; then
#     CRONTAB=${CRONTAB#"no crontab for $USER"}
#     CRONTAB="$CRONTAB"$'\n'"0 0 * * * $UPDATE_CRONJOB_SCRIPT"
#     echo "$CRONTAB" | crontab -
# fi