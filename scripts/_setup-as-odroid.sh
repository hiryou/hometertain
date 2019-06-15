#!/bin/bash
if [[ $(whoami) != 'odroid' ]]; then echo "Please run as 'odroid' user"; exit 1; fi

echo "Installing cmyip cli (python script).."
sleep 1
[[ -d "/home/odroid/github" ]] || mkdir -p "/home/odroid/github"
git clone https://github.com/hiryou/cmyip-cli.git /home/odroid/github/cmyip-cli

#pip install --upgrade pip
# https://github.com/pypa/pip/issues/5447
#hash -d pip
#sudo ln -sf $( type -P pip ) /usr/bin/pip
pip install --user BeautifulSoup4
pip install --user requests

echo "Creating a .bash_profile.."
sleep 1
touch /home/odroid/.bash_profile
cat bash_profile > /home/odroid/.bash_profile

echo "Creating plex movies & Downloads folders under odroid home.."
sleep 1
[[ -d "/home/odroid/plex/movies" ]] || mkdir -p "/home/odroid/plex/movies"
[[ -d "/home/odroid/Downloads" ]] || mkdir -p "/home/odroid/Downloads"

sudo chmod -R ug+rw "/home/odroid/plex/movies"
