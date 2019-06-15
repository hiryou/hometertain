#!/usr/bin/env bash
if [[ $(whoami) != 'root' ]]; then echo "Please run as 'root' user"; exit 1; fi
# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
locale-gen en_US.UTF-8

echo
echo "[*] Updating apts.. "
sleep 1
ps aux | grep 'apt-ge[t] up' | awk '{print $2}' | while read -r pid; do
    kill -9 ${pid}
done
apt-get update
#dpkg --configure -a
if [[ $? -ne 0 ]]; then
    echo "Failed half way, re-run this script WITHOUT restart"
    exit 1
fi

echo
echo "[*] Upgrading apts.. "
sleep 1
echo "Y" | apt-get upgrade
if [[ $? -ne 0 ]]; then
    echo "Failed half way. Restart this node then re-run this setup."
    exit 1
fi

# TODO DO NOT remove package kernel-*! It broke eth1 on USB 3.0 port!
echo
echo "[*] Auto-removing apts.. "
sleep 1
apt-mark manual kernel-common
apt-mark manual kernel*
#dpkg --configure -a
echo "Y" | apt autoremove

#rm /var/lib/dpkg/lock
#rm /var/cache/apt/archives/lock

# Install odroid utility
# 1. Resize the Boot Drive
# 2. Turn off Xorg
echo "[*] Installing odroid-utility.sh.. "
sleep 1
wget -O /usr/local/bin/odroid-utility.sh https://raw.githubusercontent.com/mdrjr/odroid-utility/master/odroid-utility.sh
chmod +x /usr/local/bin/odroid-utility.sh
read -p "[*] Modifying odroid-utility.sh. Do these 2 things: 1. Resize the Boot Drive; 2. Disable Xorg. Ready?..."
odroid-utility.sh
