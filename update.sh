#!/bin/bash

set -e

cd "$(dirname "$0")"

duration=${1:-1200}

trap "pkill -P $$" SIGINT SIGTERM EXIT

git pull
crontab ./cron.crontab

./upload.sh &
./schedule.sh $duration

wait

./usb-off.sh

echo "updated"
