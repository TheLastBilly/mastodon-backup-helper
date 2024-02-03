#!/bin/bash

source ../globals.sh

if [[ -z "$MASTODON_USER" ]]; then
    echo "Please specified your username (i.e: user@domain.tld) on the MASTODON_USER system variable"
    exit 1
fi

source "$VIRTUALENV_DIR"/bin/activate
mastodon-archive archive "$MASTODON_USER"
mastodon-archive outbox "$MASTODON_USER"