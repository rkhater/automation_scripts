#!/bin/bash
# Shell script to install postgresql
# -------------------------------------------------------------------------
# Version 0 (April 05 2016)
# -------------------------------------------------------------------------
# Copyright (c) 2016 Ramy Khater <ramy.m.khater@gmail.com>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
scrtext="Add apt.postgresql.org to sources.list ..."
echo "Add apt.postgresql.org to sources.list ..."
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

scrtext="$scrtext\nImporting repository signing key ..."
echo "Importing repository signing key ..."
sudo apt-get install wget ca-certificates
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -


scrtext="$scrtext\nUpdate and Upgrade APT ..."
echo "Update and Upgrade APT ..."
sudo apt-get update
sudo apt-get upgrade

scrtext="$scrtext\nInstalling postgresql and pgadmin3 ..."
echo "Installing postgresql and pgadmin3 ..."
sudo apt-get install postgresql postgresq-common libpq-dev pgadmin3

clear
echo -e $scrtext
echo "Done."
