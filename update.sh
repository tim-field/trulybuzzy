#!/bin/bash
cd "$(dirname "$0")"

trap "pkill -P $$" SIGINT SIGTERM EXIT

git pull
crontab ./cron.crontab
