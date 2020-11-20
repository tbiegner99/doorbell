#! /bin/bash

git pull origin
cd ./server
npm i
sudo service doorbell restart