## OS Setup

Run provided .sh scripts in scripts/
```bash
# TODO FUCK! This script broke! Don't need, as USB ethernet connects just fine by default
# TODO after removing eth0 & eth1 overrides, testspeed reported true internet speed!
./setup-xu3-eth1.sh 

hostname='plex-server'
./setup-node.sh ${hostname}
```

After restart, login as odroid user. Basic setup under odroid:
```bash
# Validate host name
hostname

# speed test cli
# https://www.howtogeek.com/179016/how-to-test-your-internet-speed-from-the-command-line/
sudo apt install speedtest-cli
speedtest

# cmyip cli  
mkdir /home/odroid/github; cd /home/odroid/github;
git clone https://github.com/hiryou/cmyip-cli.git
# pre-requisites for this tool to function
sudo apt install python-pip
pip install --upgrade pip
# https://github.com/pypa/pip/issues/5447
#hash -d pip
sudo ln -sf $( type -P pip ) /usr/bin/pip
pip install BeautifulSoup4
pip install requests
```

Create /home/odroid/.bash_profile with:
```bash
if [[ -f ~/.bashrc ]]; then
      . ~/.bashrc
fi

if [[ -f ~/.profile ]]; then
      . ~/.profile
fi

# USER CUSTOM ALIASES
alias profile-reload='source ~/.bash_profile'

function cmyip() {
    python /home/odroid/github/cmyip-cli/cmyip_cli.py
}
```

Try basic utils
```bash
profile-reload
cmyip
```