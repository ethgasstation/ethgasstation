#!/bin/bash
set -e

# Run following command to execute the script:
# cd /usr/local/SettleFinance/ethgasstation-frontend && git fetch --all && git reset --hard origin/master && git pull && chmod -R 777 /usr/local/SettleFinance/ethgasstation-frontend/upgrade.sh && ./upgrade.sh

#For Initial Setup
#	mkdir -p -v /usr/local/SettleFinance
#	cd /usr/local/SettleFinance
#	git clone https://github.com/SettleFinance/ethgasstation-frontend.git
#	git clone https://github.com/SettleFinance/ethgasstation-backend.git
#	cd ethgasstation-frontend

echo "####################################"
echo "# ETH GAS STARTION FRONEND UPGRADE #"
echo "####################################"


rm -v /usr/local/SettleFinance/common.php || echo "Backup common file was probably already removed.";
rm -r -f -v /usr/local/SettleFinance/json || echo "Backup json files were probably already removed.";

mkdir -p /var/www/ethgasstation.settle.host/public_html/json
touch /var/www/ethgasstation.settle.host/public_html/json/test
mkdir -p -v /usr/local/SettleFinance/json

cp /var/www/ethgasstation.settle.host/public_html/build/php/common.php /usr/local/SettleFinance/common.php
cp /var/www/ethgasstation.settle.host/public_html/json/* /usr/local/SettleFinance/json

echo "Stopping Apache and Backend..."
systemctl stop apache2
systemctl stop ethgassbackend

rm -r -f -v /var/www/ethgasstation.settle.host/public_html/*

cp -v -r /usr/local/SettleFinance/ethgasstation-frontend/* /var/www/ethgasstation.settle.host/public_html/

rm -f -v /var/www/ethgasstation.settle.host/public_html/build/php/common.php

cp -v /usr/local/SettleFinance/common.php /var/www/ethgasstation.settle.host/public_html/build/php/common.php

mkdir -p -v /var/www/ethgasstation.settle.host/public_html/json
cp /usr/local/SettleFinance/json/* /var/www/ethgasstation.settle.host/public_html/json

chmod -R 777 /var/www/ethgasstation.settle.host/public_html/json

echo "Startting Apache and Backend..."

systemctl start apache2
systemctl start ethgassbackend

echo "Checking Disk Space"
df

#PRO TIP's:

#echo "Geth Upgrade..."
#systemctl stop geth
#
#cd /usr/local/go-ethereum
#git reset --hard origin/release/1.8
#git checkout origin/release/1.8
#git pull origin release/1.8
#make geth
#
#systemctl restart geth

#geth status verify command:
#journalctl --unit=geth -n 100 --no-pager

#to edit geth service
#nano /lib/systemd/system/geth.service

#backend status verify
#journalctl --unit=ethgassbackend -n 100 --no-pager

#ExecStart=/usr/local/go-ethereum/build/bin/geth --syncmode "fast" --rpc --rpcapi="db,eth,net,web3,personal,txpool" --cache 1024 --rpcport 8545 --rpcaddr 127.0.0.1 --rpccorsdomain "*" --rpcvhosts "*"

