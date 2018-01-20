#!/usr/bin/env bash
echo deb https://downloads.plex.tv/repo/deb ./public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
sudo apt update
sudo apt install plexmediaserver
echo To setup Plex Media Server, open a browser window and go to http://127.0.0.1:32400/web
