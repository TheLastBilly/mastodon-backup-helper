#!/bin/bash

source globals.sh

git pull
git submodule update --init

source "$VIRTUALENV_DIR"/bin/activate

cd "$DATA_DIR"
../archive.sh

python ../mastodon-data-viewer.py/mastodon-data-viewer.py --archive ./ --cache ./ \
    --hostname "$DATA_VIEWER_HOST" --port "$DATA_VIEWER_PORT" --use-outbox
