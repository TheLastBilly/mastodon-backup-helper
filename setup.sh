#!/bin/bash

VIRTUALENV_DIR=venv
DATA_DIR=data

if [[ -z "$MASTODON_USER" ]]; then
    echo "Please specified your username (i.e: user@domain.tld) on the MASTODON_USER system variable"
    exit 1
fi
echo "setting up archive for $MASTODON_USER"

git submodule update --init --recursive

if [ ! -d "$VIRTUALENV_DIR" ]; then
    virtualenv "$VIRTUALENV_DIR"
fi
source "$VIRTUALENV_DIR"/bin/activate

cd mastodon-archive/
pip install -e .
cd ..

cd mastodon-data-viewer.py/
pip install -r requirements.txt
cd ..

if [ ! -d "$DATA_DIR" ]; then
    mkdir "$DATA_DIR"
fi

cd "$DATA_DIR"
mastodon-archive archive "$MASTODON_USER"
mastodon-archive outbox "$MASTODON_USER"