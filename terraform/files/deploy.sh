#!/bin/bash
set -e
cd ~
git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd ~/reddit
bundle install
sudo mv /tmp/puma.service /lib/systemd/system/puma.service
sudo chmod 644 /lib/systemd/system/puma.service
systemctl daemon-reload
systemctl start puma
systemctl enable puma
sudo chmod u+x /usr/local/bin/puma