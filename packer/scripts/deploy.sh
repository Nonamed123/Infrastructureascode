#!/bin/bash
set -e
cd ~
git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd ~/reddit
bundle install
mv /tmp/local /etc/init.d/local
sudo chmod +x /etc/init.d/local
sudo update-rc.d local defaults 80