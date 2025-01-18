#!/bin/bash
cd "$(dirname "$0")"

./usb-on.sh

trap "pkill -P $$" SIGINT SIGTERM EXIT

# 20 minutes default
duration=${1:-1200}

# ./look.sh $duration &
./watch.sh $duration &
./listen.sh $duration &

wait
echo "jobs done"
# upload any previous failed uploads
./upload.sh

./usb-off.sh
