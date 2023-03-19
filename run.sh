#!/bin/bash
cd "$(dirname "$0")"

trap "pkill -P $$" SIGINT SIGTERM EXIT

# echo "startup usb"
# /usr/sbin/uhubctl -l 1-1 -p 2 -a on
# sleep 90
# /usr/bin/tailscale up
# ./usb-on.sh

# 20 minutes default
duration=${1:-1200}

./look.sh $duration &
./listen.sh $duration &

wait
echo "jobs done"

# ./usb-off.sh

# echo "shutdown tailscale"
# /usr/bin/tailscale down --accept-risk=lose-ssh
# sleep 30

# echo "shutdown usb"
# sleep 2
# /usr/sbin/uhubctl -l 1-1 -p 2 -a off
