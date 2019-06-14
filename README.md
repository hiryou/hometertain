## Hometertain
![demo](img/plex-server-local.png)

![demo](img/plex-on-tv.jpg)

### System overview
Home entertainment center host on an odroid-x3/4
- Hardware: Odroid xu3/4, OS: ubuntu minimal 16.04 for xu3 (Don't try img for different boar e.g. xu4 because it won't work: apt-get upgrade corrupt the boot)
- Plex server housing media files
- Torrent service & server (transmission-daemon on ubuntu); Another machine (e.g. mac) used Transmission Remote GUI to manage torrent downloads remotely (within LAN network).
- Open VPN service running Private Internet Access (paid subscription) 
- Movies streamed on plex clients such as mobile phone, smart tv or another computer.

## Build Step
OS Setup
- [OS Image](os.md)
- Basic packages installation
    ```bash
    hostname='plex-server'
    ./setup.sh ${hostname}
    ```
- After restart, ssh to it as odroid user. If `cmyip` doesn't work, fix it manually:
```bash
pip install --user BeautifulSoup4
pip install --user requests
```

Services setup: From now run as user odroid
- [OpenVPN authorizing Private Internet Access](vpn.md)
- [Torrent server](torrent.md) 
- [Plex server](plex.md)

Enjoy!