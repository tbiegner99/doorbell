#! /bin/bash
set -e

SERVICE_NAME=doorbell
path=`pwd`

NODE_DIR=`which node`

cp $path/$SERVICE_NAME.service /etc/systemd/system

./setup-config.sh



sed -i "s|\$PWD|$path|g" /etc/systemd/system/$SERVICE_NAME.service

sed -i "s|\$NODE_DIR|$NODE_DIR|g" /etc/systemd/system/$SERVICE_NAME.service

cd ./server
npm i

systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME