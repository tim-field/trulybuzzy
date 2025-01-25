#!/bin/bash

set -e

cd "$(dirname "$0")"

duration=${1:-1200}

trap "pkill -P $$" SIGINT SIGTERM EXIT

rm -f ./upload.pid

git pull
crontab ./cron.crontab

# schedule will update the crontab scheduling run.sh
./schedule.sh $duration

wait

./usb-off.sh

echo "updated"
