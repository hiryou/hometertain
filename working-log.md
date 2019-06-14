TODO might need to change back to ubuntu 18.04

To fix broken links after installation:
sudo apt-get install -f

Hometertain system at a glance
- Ubuntu mate 18.04 for arm; A headless ubuntu is sufficient as well, as we don't need GUI
- Setup Plex server
- openvpn with Private Internet Access
- Setup transmission-daemon as torrent client. To connect from mac laptop for e.g.: use Transmission Remote GUI
	$ sudo apt-get install transmission-daemon
	http://macappstore.org/transmission-remote-gui/
- Change hostname for easy access
	$ hostname plex
	$ sudo nano /etc/hostname "plex"
-----------
Upon system reboot:
- Manual check: Private Internet Access via openvpn (now service too)
- Custom python script: cmyip
	https://github.com/hiryou/cmyip-cli
- plex: already started (service)
- transmission-daemon (service)
--------
[TODO] Write cron script to keep checking cmyip; stop transmission-daemon service if true IP is disclosed

Plex UI
http://plex.local:32400/web/index.html

How setup plex server as a service on ubuntu
https://linuxize.com/post/how-to-install-plex-media-server-on-ubuntu-18-04/
	- Skip the firewall section (as default ubuntu minimal/mate version doesn't have firewall). TODO: Verify

All steps to change run-under user for transmission-daemon
- http://www.ephestione.it/change-user-of-transmission-daemon-under-debian-and-raspbian/
	* NOTE! Do not do the last 2 steps: no need:
	run sudo chown -R user:user /etc/transmission-daemon/
	run sudo chown -R user:user /var/lib/transmission-daemon/
- https://askubuntu.com/questions/261252/how-do-i-change-the-user-transmission-runs-under/544185#544185

transmission-daemon set auth and other things
https://superuser.com/questions/113649/how-do-you-set-a-password-for-transmission-daemon-the-bittorrent-client-server

Either location of transmission-daemon config:
Origin: /etc/transmission-daemon/settings.json
~/.config/transmission-daemon/settings.json (seemed to happen after changing user/permission to droid user)

cmds in order, if changing transmission-daemon settings.json:
$ sudo service transmission-daemon stop
$ pkill -HUP transmission-da
$ transmission-daemon -a 127.0.0.1,192.168.0.*  # add IP whitelist
- right after doing this command, check ~/.config/transmission-daemon/settings.json. It should have the IP whitelist you specified above
$ sudo service transmission-daemon start
Sometimes, a computer reboot helps, e.g. error 'address already in use error'

This is for manual PIA, just for ref. Use below step instead to run openvpn headless upon boot
Using Private Internet Access on ARM: via openvpn
sudo apt-get install uuid-runtime
- Then follow this normal process 
	https://www.privateinternetaccess.com/helpdesk/guides/linux/linux/linux-ubuntu-installing-openvpn
	* Stop after completing step 8


DO THIS INSTEAD: https://www.htpcguides.com/autoconnect-private-internet-access-vpn-boot-linux/
Steps to config openvpn auto connect at boot
- Copy list of .ovpn config files from PIA provider: https://www.privateinternetaccess.com/openvpn/openvpn.zip. Extract it obtaining a list of .ovpn files
	Each .ovpn file is a VPN proxy
	Source: https://www.htpcguides.com/autoconnect-private-internet-access-vpn-boot-linux/
- Under /etc/openvpn/, create login.txt: 1st line = PIA username, 2nd line = PIA password
- Choose any .ovpn file for auto connect, confirmed working reliably: CA Toronto. Rename this .ovpn to any-name-is-fine.conf and put under /etc/openvpn/
	Edit this .conf file, append line "auth-user-pass" with "/etc/openvpn/login.txt" (path to auth file)
		i.e.: "auth-user-pass /etc/openvpn/login.txt"
	Source: https://askubuntu.com/questions/426211/auto-start-openvpn-with-one-ovpn-file/426217
$ sudo systemctl daemon-reload
Reboot the system
Run $ cmyip to verify VPN is activated

The equivalent cmd to connect manually is:
$ sudo openvpn --config '/etc/openvpn/ovpn/CA Toronto.ovpn' --auth-user-pass /etc/openvpn/login.txt

OTHERS
Lightweight OS for ARM
- https://www.electromaker.io/blog/article/13-best-operating-systems-for-the-odroid-xu4-odroid-xu4-supported-os-options
- https://www.linux.com/news/6-excellent-lightweight-linux-distros-x86-and-arm
- https://www.igorkromin.net/index.php/2016/09/14/odroidxu4-dietpi-plex-deluge-webmin-awesome-home-mediafile-server/

Config PIA on different torrent clients
- https://www.vpnuniversity.com/bittorrent/how-to-use-private-internet-access-for-torrents
- https://www.vpnuniversity.com/bittorrent/torrent-proxy-guide#setup

Install PIA alternate setup
https://www.privateinternetaccess.com/helpdesk/kb/articles/how-do-i-install-the-pia-app-or-use-alternate-setups
transmission cli
https://www.maketecheasier.com/how-to-download-torrents-from-the-command-line-in-ubuntu/
https://manpages.debian.org/testing/transmission-cli/transmission-remote.1.en.html
list remote torrents in host from client
https://askubuntu.com/questions/747050/transmission-remote-how-to-monitor-list-of-torrents-in-terminal

Make machine accessible within LAN using hostname
https://unix.stackexchange.com/questions/16890/how-to-make-a-machine-accessible-from-the-lan-using-its-hostname

xu3 board and USB 3.0 gigabit ethernet dongle issue
https://forum.odroid.com/viewtopic.php?f=99&t=15130