#!/bin/bash
cd "$(dirname "$0")"

trap "pkill -P $$" SIGINT SIGTERM EXIT

echo "startup usb"
uhubctl -l 1-1 -p 2 -a 1
sleep 5

# 20 minutes
duration=${1:-1200}

./look.sh $duration &
./listen.sh $duration &

wait

echo "shutdown usb"
uhubctl -l 1-1 -p 2 -a 0
