#!/bin/bash
cd "$(dirname "$0")"
set -e

trap "echo Listener Exited!; exit;" SIGINT SIGTERM
#trap 'echo "Inside trap"; echo "Line $LINENO."' ERR

mkdir -p ./samples/audio
mkdir -p ./working

# Total duration, defaults to 20 minutes
duration=${1:-1200}

# duration will be split into into max 60 minute segments
segment=$((duration < 3600 ? duration : 3600))

device=$(arecord -l | grep -m 1 '^card [0-9]:' | awk '{print $2}' | sed 's/://')
if [ -z "$device" ]; then
	echo "No capture device found!"
	exit 1
fi

echo "Listening for $duration seconds on device $device"

while [ $duration -gt 0 ]; do
	echo "duration: $duration segment:$segment"
	file="capture-$(date +%Y-%m-%dT%H-%M-%S).opus"
	arecord -r 48000 --device hw:$device,0 -f S16_LE --duration $segment -t raw | opusenc --raw-chan 1 --bitrate 128 - ./working/audio-current.opus
	mv ./working/audio-current.opus ./samples/audio/$file
	rsync --remove-source-files -vP ./samples/audio/$file tim@mohiohio.com:buzzy/samples/audio/$file &
	duration=$((duration - segment))
	echo "completed segment $file"
done

wait
echo "finished listen"
