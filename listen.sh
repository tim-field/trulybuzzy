#!/bin/bash
cd "$(dirname "$0")"

trap "echo Listener Exited!; exit;" SIGINT SIGTERM

mkdir -p ./samples/audio
mkdir -p ./working

# Total duration, defaults to 20 minutes
duration=${1:-1200}

# duration will be split into into max 20 minute segments
segment=$((duration<1200 ? duration : 1200))

echo "duration: $duration segment:$segment"


while [ $duration -gt 0 ] ;
do
	arecord -r 48000 --device hw:1,0  -f S16_LE --duration $segment -t raw | opusenc --raw-chan 1 --bitrate 128 - ./working/audio-current.opus
	mv ./working/audio-current.opus ./samples/audio/capture-`date +%Y-%m-%dT%H-%M-%S`.opus
	((duration -= segment))
done
