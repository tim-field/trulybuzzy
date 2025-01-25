#!/bin/bash

# Run is scheduled via cron, the schedule is set by schedule.sh

cd "$(dirname "$0")"

./usb-on.sh

trap "pkill -P $$" SIGINT SIGTERM EXIT

# 20 minutes default
duration=${1:-1200}

./upload.sh &
# ./look.sh $duration &
./watch.sh $duration &
./listen.sh $duration &
./schedule.sh $duration &

wait
echo "jobs done"

./usb-off.sh
