#!/bin/sh
# script used by OpenVPN to setup a route on Linux.
# used in conjunction with OpenVPN config file options
# script-security 2, route-noexec, route-up
# script also requires route table rt2
# sudo bash -c 'echo "1 rt2" >> /etc/iproute2/rt_tables

help() {
  echo "For setting OpenVPN routes on Linux."
  echo "Usage: $0 up"
}

up() {
  # sleep to make sure VPN connection is establish before attempting to request for a forwarded port
  echo "Prepare to request port forwarding from PIA..."
  sleep 4
  /etc/openvpn/pia-port-fw.sh &
}

case $1 in
  "up") up;;
  *) help;;
esac

# always flush route cache
ip route flush cache