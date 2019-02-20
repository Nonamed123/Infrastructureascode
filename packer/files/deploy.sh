#!/bin/bash
set -e

if [ "$(ruby -v)" == 'ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]' ]; then
	echo "true install ruby"
else
	echo "false install ruby"
fi

if [ "$(bundle -v)" == 'Bundler version 1.11.2' ]; then
        echo "true install bundler"
else
        echo "false install bundler"
fi

git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd reddit
bundle install

if [ -n "$(systemctl status mongod | grep running)" ]; then
	echo "true install & start mongod"
else
	echo "false install & start mongod"
fi

wget https://raw.githubusercontent.com/Buldozer83a/testd/master/packer/files/deamon -O /etc/init.d/deamon
chmod +x /etc/init.d/deamon
update-rc.d deamon defaults 90
/etc/init.d/deamon start

if [ "$(ps aux | grep puma | grep -v grep | wc -l)" == "1" ]; then
	echo "true install puma"
else
	echo "false install puma"
fi

sleep 2

if [ "$(curl localhost:9292 | wc -l)" != 0 ]; then
        echo "true reddit work"
else
        echo "false reddit work"
fi