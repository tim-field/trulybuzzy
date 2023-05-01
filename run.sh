#!/bin/bash
cd "$(dirname "$0")"
trap "pkill -P $$" SIGINT SIGTERM EXIT

# 20 minutes default
duration=${1:-1200}

./look.sh $duration &
./listen.sh $duration &

wait
echo "jobs done"

./video.sh
