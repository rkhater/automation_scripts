#!/bin/bash
# Shell script to install redis
# -------------------------------------------------------------------------
# Version 0 (March 07 2016)
# -------------------------------------------------------------------------
# Copyright (c) 2016 Ramy Khater <ramy.m.khater@gmail.com>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
scrtext="Updating APT ..."
echo "Updating APT ..."
sudo apt-get -qq update

scrtext="$scrtext\nInstalling depnednecies ..."
scrtext="$scrtext\n- gcc package ..."
echo "Installing depnednecies ..."
echo "- gcc package ..."
sudo apt-get -qq install gcc
echo "- libc6-dev package ..."
sudo apt-get -qq install libc6-dev
echo "- make package ..."
sudo apt-get -qq install make
echo "- curl package ..."
sudo apt-get -qq install curl
echo "- build-essential package ..."
sudo apt-get -qq install build-essential
echo "- tcl8.5 package ..."
sudo apt-get -qq install tcl8.5

echo "Downloading redis latest stable version ..."
mkdir -p ~/Downloads
cd ~/Downloads
wget http://download.redis.io/releases/redis-stable.tar.gz

echo "Extracting redis files ..."
tar -xzf redis-stable.tar.gz

echo "installing redis ..."
cd ~/Downloads/redis-stable
make
make test
sudo make install
echo -n | ~/Downloads/redis-stable/utils/install_server.sh

echo "Configuring redis ..."
# See: http://redis.io/topics/faq
sysctl vm.overcommit_memory=1
# Bind Redis to localhost. Comment out to make available externally.
sed -ie 's/# bind 127.0.0.1/bind 127.0.0.1/g' /etc/redis/6379.conf

echo "----------------------------------"
echo "Cleaning up things ..."
rm -rf ~/Downloads/redis-stable*

echo "Checking redis ..."
sudo service redis_6379 status
cls
echo $scrtext
