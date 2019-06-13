#!/usr/bin/env bash
if [[ $(whoami) != 'root' ]]; then echo "Please run as 'root' user"; exit 1; fi
# Source: https://www.htpcguides.com/autoconnect-private-internet-access-vpn-boot-linux/

echo
echo "[*] Updating apts.. "
sleep 1
apt-get update
apt-get install openvpn unzip -y

echo
echo "[*] Downloading VPN confs form private internet access.. "
sleep 1
wget --no-check-certificate https://www.privateinternetaccess.com/openvpn/openvpn.zip -O /etc/openvpn/openvpn.zip
mkdir -p /etc/openvpn/openvpn
unzip /etc/openvpn/openvpn.zip -d /etc/openvpn/openvpn/

echo
echo "[*] Creating creds file with PIA.. "
sleep 1
cp pia-login.txt /etc/openvpn/login.txt
read -p '[TODO] Modify /etc/openvpn/login.txt with your actual Private Internet Access username & password..'
chmod 700 /etc/openvpn/login.txt

# fix DNS issue
echo
echo "[*] Using Google DNS.. "
sleep 1
line1="nameserver 8.8.8.8"
line2="nameserver 8.8.4.4"
cnt=$(grep "$line1" /etc/sysctl.conf | wc -l)
if [[ ${cnt} -eq 0 ]]; then
    echo "nameserver 8.8.8.8" | tee -a /etc/resolv.conf
fi
cnt=$(grep "$line2" /etc/sysctl.conf | wc -l)
if [[ ${cnt} -eq 0 ]]; then
    echo "nameserver 8.8.4.4" | tee -a /etc/resolv.conf
fi
chattr +i /etc/resolv.conf

echo
echo "[*] Using default VPN conf at startup: CA Toronto.. "
sleep 1
cp "/etc/openvpn/CA Toronto.ovpn" /etc/openvpn/default.conf
line1="auth-user-pass [^/]*/etc/openvpn/login.txt"
cnt=$(grep "$line1" /etc/sysctl.conf | wc -l)
if [[ ${cnt} -eq 0 ]]; then
    echo "auth-user-pass [^/]*/etc/openvpn/login.txt" | tee -a /etc/resolv.conf
fi


