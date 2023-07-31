#!/bin/bash

set -e

cd "$(dirname "$0")"

duration=${1:-1200}

json=$(curl -s "https://api.sunrise-sunset.org/json?lat=-45.782474&lng=170.507323&formatted=0")

# sunrise=$(echo $json | jq -r '.results.civil_twilight_begin')
sunrise=$(echo $json | jq -r '.results.nautical_twilight_begin')

localtime=$(date -d "$sunrise" +'%Y-%m-%dT%H:%M:%S%z')

hour=$(date -d "$localtime" +'%H')

minute=$(date -d "$localtime" +'%M')

output=$(crontab -l | sed "/\/home\/tim\/listen\/run.sh/ s/55 6/$minute $hour/")

# remove current line
crontab -l | grep -v "/home/tim/listen/run.sh" | crontab -

(
	crontab -l
	echo "$minute $hour * * * /home/tim/listen/run.sh $duration; sudo /usr/sbin/shutdown -h now"
) | crontab -
