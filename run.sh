#!/bin/bash

trap "pkill -P $$" SIGINT SIGTERM EXIT

./look.sh &
./listen.sh &

jobs -p

./upload.sh

#wait
