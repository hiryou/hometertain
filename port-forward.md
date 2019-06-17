## Port Forwarding
* Append these lines to the default .conf used by openvpn e.g. `/etc/openvpn/default.conf`
    ```bash
    # allows the ability to run user-defined script
    script-security 2
    
    # run our script to make routes
    route-up "/etc/openvpn/pia-vpn-route.sh up"
    ```
* Copy `pia-*.sh` scripts to `/etc/openvpn/`, chmod 755 them
* When `openvpn@default` service started, these scripts run and request a forwarded port from PIA. Check the service 
status to see what port it was
    ```bash
    sudo service openvpn@default status
    ...
    Loading port forward assignment information...
    {"port":54321}  
    ```
  Sometimes this message shows up instead:
    ```bash
    Loading port forward assignment information...
    Port forwarding is already activated on this connection, has expired, or you are not connected to a PIA region that 
      supports port forwarding
    ```
  If this happens, stop then start `openvpn@default` service again to request a new port. Or this message could mean the 
  last port is reused so there's no need to change transmission-daemon settings.json (TODO verify this)
* Use this port to set the peer-port in `~/.config/transmission-daemon/settings.json` and 
`/etc/transmission-daemon/settings.json`, then reload & restart transmission service:
    ```bash
    sudo service transmission-daemon reload
    sudo service transmission-daemon restart  
    ```
* I DID NOT have to forward the port in my router 

Integrate correct forwarded port appears to boost seed/upload speed. Download speed was fine without port forwarding.
## Credits
* https://www.privateinternetaccess.com/forum/discussion/23431/new-pia-port-forwarding-api
* https://www.pantz.org/software/openvpn/openvpn_with_private_internet_access_and_port_forwarding.html
* https://www.privateinternetaccess.com/helpdesk/kb/articles/how-do-i-enable-port-forwarding-on-my-vpn