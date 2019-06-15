#!/bin/bash
# Proper header for a Bash script.
# How to execute script under another user https://unix.stackexchange.com/questions/394461/linux-switch-user-and-execute-command-immediately
if [[ $(whoami) != 'root' ]]; then echo "Please run as 'root' user"; exit 1; fi
# Fix perl complaining error of some missing locales. See https://gist.github.com/panchicore/1269109
locale-gen en_US.UTF-8

hostname="$1"
if [[ -z ${hostname} ]]; then
    echo "  1st param hostname is required. E.g.: ./setup.sh plex-server"
    exit 1
fi

echo "[**] Creating user odroid.. "
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

# change hostname
echo "[*] Setting hostname to: $hostname.."
sleep 1
echo ${hostname} > /etc/hostname
hostname ${hostname}
echo
# Append to /etc/hosts
cnt=$(grep "$hostname" /etc/hosts | wc -l)
if [[ ${cnt} -eq 0 ]]; then
    echo '' >> /etc/hosts
    echo "127.0.0.1     $hostname" >> /etc/hosts
fi
echo '---- /etc/hosts ----'
cat /etc/hosts
echo '--------------------'
echo
sleep 1

echo "Installing speedtest-cli.."
sleep 1
echo "Y" | apt install speedtest-cli

echo "Installing python-pip.."
sleep 1
echo "Y" | apt install python-pip

echo "[*] Setup VPN.."
sleep 1
sudo -H -u root bash -c 'bash _setup-vpn.sh'

echo "[*] Setup for odroid user.."
sleep 1
sudo -H -u odroid bash -c 'bash _setup-as-odroid.sh'

echo "[*] Setup torrent & plex server.."
sleep 1
sudo -H -u root bash -c 'bash _setup-torrent-plex.sh'

read -p "[**] Finished setup for $hostname, restarting now. [Enter] "
shutdown -r now

