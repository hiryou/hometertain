#!/bin/bash
# Proper header for a Bash script.
# How to execute script under another user https://unix.stackexchange.com/questions/394461/linux-switch-user-and-execute-command-immediately
if [[ $(whoami) != 'root' ]]; then echo "Please run as 'root' user"; exit 1; fi

hostname="$1"
if [[ -z ${hostname} ]]; then
    echo "  1st param hostname is required. E.g.: ./setup.sh plex-server"
    exit 1
fi

# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
locale-gen en_US.UTF-8

# apt update, upgrade and stuffs
sudo -H -u root bash -c "bash _apt-get-update.sh"

echo "[**] Running setup.. "
sleep 1
# Create user 'odroid' in sudo group if not yet exists
id -u odroid &>/dev/null || {
	sleep 1
	useradd -m -p $(openssl passwd -1 odroid) odroid
	echo "Created user: odroid"
}
adduser odroid sudo
# make sure user odroid users bash shell
chsh -s /bin/bash odroid
echo "Added user 'odroid' to sudo group"

# Install odroid utility
# 1. Resize the Boot Drive
# 2. Turn off Xorg
echo "[*] Installing odroid-utility.sh.. "
sleep 1
wget -O /usr/local/bin/odroid-utility.sh https://raw.githubusercontent.com/mdrjr/odroid-utility/master/odroid-utility.sh
chmod +x /usr/local/bin/odroid-utility.sh
read -p "[*] Modifying odroid-utility.sh. Do these 2 things: 1. Resize the Boot Drive; 2. Disable Xorg. Ready?..."
odroid-utility.sh

# change hostname
echo "[*] Setting hostname to: $hostname.."
sleep 1
echo ${hostname} > /etc/hostname
hostname ${hostname}
echo
# Append to /etc/hosts
echo ' ' >> /etc/hosts
echo "127.0.0.1     $hostname" >> /etc/hosts
echo '---- /etc/hosts ----'
cat /etc/hosts
echo '--------------------'
echo
sleep 1

# Done
read -p "[*] DONE [Enter] "

echo "[*] Running setup under odroid user.."
sleep 1
sudo -H -u odroid bash -c 'bash _setup-as-odroid.sh'

echo "[*] Installing open vpn.."
sleep 1
sudo -H -u root bash -c 'bash _install-openvpn.sh'

read -p "[**] Finished setup for $hostname, restarting now. [Enter] "
sudo shutdown -r now

