#!/usr/bin/env bash
if [[ $(whoami) != 'root' ]]; then echo "Please run as 'root' user"; exit 1; fi
# Source https://linuxize.com/post/how-to-install-plex-media-server-on-ubuntu-18-04/

echo "[**] Registering plex apt repo.."
sleep 1
curl https://downloads.plex.tv/plex-keys/PlexSign.key | apt-key add -
echo deb https://downloads.plex.tv/repo/deb public main | tee /etc/apt/sources.list.d/plexmediaserver.list

echo "[**] Installing plex main packages.."
sleep 1
apt install apt-transport-https
apt update

# Configuration file '/etc/apt/sources.list.d/plexmediaserver.list'
# ==> File on system created by you or by a script.
# ==> File also in package provided by package maintainer.
#   What would you like to do about it ?  Your options are:
#    Y or I  : install the package maintainer's version
#    N or O  : keep your currently-installed version
#      D     : show the differences between the versions
#      Z     : start a shell to examine the situation
# The default action is to keep your current version.
#*** plexmediaserver.list (Y/I/N/O/D/Z) [default=N] ? 	Y
echo "Y" | apt install plexmediaserver

chown -R odroid:plex "/home/odroid/plex"

# finally
systemctl daemon-reload
