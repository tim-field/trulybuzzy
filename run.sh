#!/bin/bash

# Run is scheduled via cron, the schedule is set by schedule.sh

cd "$(dirname "$0")"

./usb-on.sh

trap "pkill -P $$" SIGINT SIGTERM EXIT

# 20 minutes default
duration=1200
sunrise=""

# Parse command-line options
while getopts "d:s" opt; do
	case $opt in
	d) duration=$OPTARG ;;
	s) sunrise=$OPTARG ;;
	*)
		echo "Usage: $0 [-d duration] [-s sunrise HH:MM]" >&2
		exit 1
		;;
	esac
done

# Validate sunrise format if present
if [ -n "$sunrise" ]; then
	if ! [[ $sunrise =~ ^([01][0-9]|2[0-3]):[0-5][0-9]$ ]]; then
		echo "Error: sunrise must be in HH:MM format" >&2
		exit 1
	fi
fi

./upload.sh &
# ./look.sh $duration &

# 20 minutes max for watch
./watch.sh -d $((duration < 1200 ? duration : 1200)) ${sunrise:+-s "$sunrise"} &

./listen.sh $duration &
./schedule.sh $duration &

wait
echo "jobs done"

# ./usb-off.sh

echo "shutting down"
sudo /usr/sbin/shutdown -h now
