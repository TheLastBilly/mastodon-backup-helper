# STILL A WORK IN PROGRESS, USE WITH CAUSION
I put this together in a couple of hours, it's not particularly clever and it hasn't been tested properly. This is more of a tool for those who have troubles setting up automated backups with [mastodon-archive](https://github.com/kensanata/mastodon-archive) and/or with my branch of [mastodon-data-viewer](https://github.com/blackle/mastodon-data-viewer.py).

`quickstart.sh` should clone this repository, install missing dependencies (git, virtualenv and pip), setup a virtualenv for the two scripts, setup an systemd user script for the Web UI and periodic backups. However, this still connects and interacts with your Mastodon account, and there might be unexpected issues with the way I mastodon-archive, so please use carefully, and do take your time to read this repo if you can.

# Mastodon Backup Helper

Quick and dirty script for setting up automatic backups and an web-based backup browser for Mastodon accounts. Still a work in progress, but should work under Debian based systems (tested on a clean install of Debian 12).

## Automatic install
Just run the following command on your terminal
```bash
bash <(curl -s https://raw.githubusercontent.com/TheLastBilly/mastodon-backup-helper/main/quickstart.sh)
```

The script will ask you for the port and hostname for the webserver, thought you can leave those blank to use the defaults. You will have to input your mastodon username in `user@domain.tld` format.
