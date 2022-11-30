#!/bin/bash
cd "$(dirname "$0")"

trap "pkill -P $$" SIGINT SIGTERM EXIT

echo "startup usb"
/usr/sbin/uhubctl -l 1-1 -p 2 -a on
sleep 60
/usr/bin/tailscale up

# 20 minutes
duration=${1:-1200}

./look.sh $duration &
./listen.sh $duration &

wait

echo "shutdown tailscale"
/usr/bin/tailscale down --accept-risk=lose-ssh
sleep 30

echo "shutdown usb"
sleep 2
/usr/sbin/uhubctl -l 1-1 -p 2 -a off
