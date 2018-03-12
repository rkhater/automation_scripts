#!/bin/bash
##
# Upgrade postgresql from 9.x to 10.x
# OS: Ubuntu
# Author: Ramy Khater <ramy.m.khater@gmail.com>
# Date: Mar 11, 2018
##

if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  if [[ $ID = ubuntu ]]; then
    codename=$(awk -F'[" ]' '/VERSION=/{print tolower(substr($4,2));}' /etc/os-release)
  else
    echo "Not running an Ubuntu distribution. ID=$ID, VERSION=$VERSION"
  fi
else
  # Not running a distribution with /etc/os-release available
  codename=$(lsb_release -c | awk '{print $2}')
fi

# Extract old PG version
old_ver=$(pg_lsclusters | awk 'NR==2{print $1}')
if [[ $old_ver -ge 10 ]]; then
  echo "You already have Postgresql Version "$old_ver
  exit 0
fi

backup_file="pgdump_$(date +"%m_%d_%y")"
if [ -f $backup_file ]; then
  echo "Cleaning up old backup"
  rm -f $backup_file
fi
echo "Make a backup."
pg_dumpall > $backup_file

echo "Install Postgres 10. A newer version will be installed side-by-side with the earlier version."
# Follow instructions on this page: https://www.postgresql.org/download/linux/ubuntu/
repository_imported=$(cat /etc/apt/sources.list.d/pgdg.list | grep -c "deb http://apt.postgresql.org/pub/repos/apt/ $codename-pgdg main")
if [ $repository_imported -eq 0 ]; then
  sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ $codename-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -
  sudo apt-get update
fi
sudo apt-get install -y postgresql-10

# Installation by default creates a cluster main for 10.
# This is done so that a fresh installation works out of the box without the need to create a cluster first,
# but of course it clashes when you try to upgrade 9.x/main when 10/main also exists.
# The recommended procedure is to remove the 10 cluster with pg_dropcluster and then upgrade with pg_upgradecluster.
#
# By running pg_lsclusters you'll list all pg clusters:
#Ver Cluster Port Status Owner    Data directory               Log file
#9.6 main    5432 online postgres /var/lib/postgresql/9.6/main /var/log/postgresql/postgresql-9.6-main.log
#10  main    5433 online postgres /var/lib/postgresql/10/main  /var/log/postgresql/postgresql-10-main.log


# Stop the 10 cluster and drop it.
sudo pg_dropcluster 10 main --stop

# Stop all processes and services writing to the database.
echo "Stop the database."
sudo systemctl stop postgresql

echo "Upgrade the $old_ver cluster."
sudo pg_upgradecluster -m upgrade $old_ver main

pg_lsclusters
read -r -p "Your $old_ver cluster should now be 'down', and the 10 cluster should be online at 5432 [y/N]: " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
  do_something
  echo "First, check that everything works fine. After that, remove the $old_ver cluster:"
  read -r -p "Upgraded successfully, Isn't? [y/N]: " response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
  then
    echo "Awesome!! Lets cleanup things."
    sudo pg_dropcluster $old_ver main --stop
    sudo apt-get autoremove --purge postgresql-$old_ver
  else
    help
  fi
else
  help
fi

help() {
  echo "Oops!! :("
  echo "Let me see how i can help, Check this"
  echo "1- Docs: https://www.postgresql.org/docs/10/static/upgrading.html"
  echo "2- hat happens if I interrupt or cancel pg_upgradecluster? https://dba.stackexchange.com/questions/173382/what-happens-if-i-interrupt-or-cancel-pg-upgradecluster/173400"
  echo "3- Ubuntu manpage for pg_upgradecluster: http://manpages.ubuntu.com/manpages/trusty/en/man8/pg_upgradecluster.8.html"
}
