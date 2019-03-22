#!/bin/bash
set -e
mv /tmp/puma.service /lib/systemd/system/puma.service
sudo chmod 644 /lib/systemd/system/puma.service
systemctl daemon-reload
systemctl start puma
systemctl enable puma
sudo chmod u+x /usr/local/bin/puma