#!/bin/bash
if [[ $(whoami) != 'odroid' ]]; then echo "Please run as 'odroid' user"; exit 1; fi

echo "Installing speedtest-cli.."
sleep 1
sudo apt install speedtest-cli

echo "Installing cmyip cli (python script).."
sleep 1
mkdir /home/odroid/github
git clone https://github.com/hiryou/cmyip-cli.git /home/odroid/github/cmyip-cli
# pre-requisites for this tool to function
sudo apt install python-pip
pip install --upgrade pip
# https://github.com/pypa/pip/issues/5447
#hash -d pip
#sudo ln -sf $( type -P pip ) /usr/bin/pip
pip install BeautifulSoup4
pip install requests

echo "Creating a .bash_profile.."
sleep 1
touch /home/odroid/.bash_profile
cat bash_profile > /home/odroid/.bash_profile
