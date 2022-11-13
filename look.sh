#!/bin/bash
cd "$(dirname $0"")"

trap "echo Look Exited!; exit;" SIGINT SIGTERM

mkdir -p ./samples/images

# Caputre images over this many seconds, defaults to 20 minutes
duration=${1:-1200}

# Take an image at this interval over the duration
loop=$((duration<1200 ? duration : 1200))


while [ $duration -gt 0 ] ;
do
	fswebcam -S 20 -p YUYV -r 2592x1944 --save ./samples/images/pic-%Y-%m-%d_%H-%M-%S.jpg
	sleep $loop 
	((duration -= loop))
done;
