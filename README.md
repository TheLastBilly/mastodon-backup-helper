# Mastodon Backup Helper

Quick and dirty script for setting up automatic backups and an web-based backup browser for Mastodon accounts. Still a work in progress, but should work under Debian based systems.

Just run the following command on your terminal
```bash
bash <(curl -s https://raw.githubusercontent.com/TheLastBilly/mastodon-backup-helper/main/quickstart.sh )
```

The script will ask you for the port and hostname for the webserver, thought you can leave those blank to use the defaults. You will have to input your mastodon username in `user@domain.tld` format.
