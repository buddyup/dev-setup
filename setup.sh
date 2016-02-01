#!/usr/bin/env bash

mkdir -p ~/bootstrap
curl https://raw.githubusercontent.com/buddyup/dev-setup/master/.dots > ~/bootstrap/dots.sh
cd ~/bootstrap
chmod +x dots.sh
./dots.sh all