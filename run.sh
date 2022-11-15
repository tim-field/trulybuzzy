#!/bin/bash
cd "$(dirname "$0")"

trap "pkill -P $$" SIGINT SIGTERM EXIT

# 20 minutes
duration=${1:-1200}  

./look.sh $duration &
./listen.sh $duration &

jobs -p

./upload.sh

#wait
