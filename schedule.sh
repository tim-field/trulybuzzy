#!/bin/bash

set -e

cd "$(dirname "$0")"

duration=${1:-1200}

json=$(curl -s "https://api.sunrise-sunset.org/json?lat=-45.769611&lng=170.607640&formatted=0")

twilight=$(echo $json | jq -r '.results.civil_twilight_begin')
sunrise=$(echo $json | jq -r '.results.sunrise')

localStartTime=$(date -d "$twilight" +'%Y-%m-%dT%H:%M:%S%z')

startHour=$(date -d "$localStartTime" +'%H')
startMinute=$(date -d "$localStartTime" +'%M')

localSunrise=$(date -d "$sunrise" +'%H:%M')
sunriseHour=$(date -d "$localSunrise" +'%H')
sunriseMinute=$(date -d "$localSunrise" +'%M')

#echo "$minute $hour * * * /home/tim/listen/run.sh $duration; sudo /usr/sbin/shutdown -h now"

# remove current line
crontab -l | grep -v "/home/tim/listen/run.sh" | crontab -

(
	crontab -l
	echo "$startMinute $startHour * * * /home/tim/listen/run.sh -d $duration -s $sunriseHour:$sunriseMinute"
) | crontab -
