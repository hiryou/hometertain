#!/usr/bin/env bash
if [[ $(whoami) != 'root' ]]; then echo "Please run as 'root' user"; exit 1; fi

function trans_settings() {
    file=$1
    if [[ ! -f ${file} ]]; then
        echo "File not exist"
        exit 1
    fi
    sed -i 's/"download-dir":.*/"download-dir": "\/home\/odroid\/plex\/movies",/' ${file}
    sed -i 's/"incomplete-dir":.*/"incomplete-dir": "\/home\/odroid\/Downloads",/' ${file}
    sed -i 's/"rpc-password":.*/"rpc-password": "odroid",/' ${file}
    sed -i 's/"rpc-username":.*/"rpc-username": "odroid",/' ${file}
    sed -i 's/"rpc-whitelist":.*/"rpc-whitelist": "127.0.0.1,192.168.0.*",/' ${file}
    sed -i 's/"rpc-whitelist-enabled":.*/"rpc-whitelist-enabled": true,/' ${file}
}

command -v transmission-daemon || {
    echo "  Installing transmission-daemon.."
    sleep 1
    echo "Y" | apt-get install transmission-daemon;
}
usermod -a -G debian-transmission odroid

echo "  transmission-daemon: Change run-as user to odroid.."
sleep 1
service transmission-daemon stop
systemctl stop transmission-daemon.service
sed -i 's/USER=.*/USER=odroid/' /etc/init.d/transmission-daemon
sed -i 's/User=.*/User=odroid/' /lib/systemd/system/transmission-daemon.service
#----
sed -i 's/setuid.*/setuid odroid/' /etc/init/transmission-daemon.conf
sed -i 's/setgid.*/setgid odroid/' /etc/init/transmission-daemon.conf
#----

# finally
systemctl daemon-reload
# right after this step, /home/odroid/.config/transmission-daemon/ is created
service transmission-daemon start
systemctl start transmission-daemon.service

echo "  Altering settings.json.."
sleep 1
service transmission-daemon stop
systemctl stop transmission-daemon.service
# /etc/transmission-daemon/settings.json
file1=/etc/transmission-daemon/settings.json
file2=/home/odroid/.config/transmission-daemon/settings.json
[[ -f ${file1} ]] && trans_settings ${file1}
[[ -f ${file2} ]] && trans_settings ${file2}
service transmission-daemon start
systemctl start transmission-daemon.service
