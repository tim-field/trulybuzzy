#!/bin/bash
cd "$(dirname "$0")"

git pull
crontab ./cron.crontab
