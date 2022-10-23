#!/bin/bash

trap "echo Exited!; exit;" SIGINT SIGTERM

mkdir -p ./samples/audio
mkdir -p ./working

# 2 hours is 7200

while :
do
	arecord -r 48000 --device hw:1,0  -f S16_LE --duration 7200 -t raw | opusenc --raw-chan 1 --bitrate 128 - ./working/audio-current.opus
	mv ./working/audio-current.opus ./samples/audio/capture-`date +%Y-%m-%dT%H:%M:%S`.opus
done

