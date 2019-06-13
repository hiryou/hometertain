#!/usr/bin/env bash
if [[ $(whoami) != 'root' ]]; then echo "Please run as 'root' user"; exit 1; fi

echo
echo "[*] Updating apts.. "
sleep 1
apt-get update
#dpkg --configure -a
if [[ $? -ne 0 ]]; then
    echo "Failed half way, re-run this script"
    exit 1
fi

echo
# TODO This seemed to cause boot halting problem on xu3 after reboot
echo "[*] Upgrading apts.. "
sleep 1
echo "Y" | apt-get upgrade
if [[ $? -ne 0 ]]; then
    echo "Failed half way. Restart this node then re-run this setup."
    exit 1
fi

echo
echo "[*] Auto-removing apts.. "
sleep 1
echo "Y" | apt autoremove

#rm /var/lib/dpkg/lock
#rm /var/cache/apt/archives/lock
