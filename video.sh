#!/bin/bash
cd "$(dirname $0"")"
set -e

trap "echo Video Exited!; exit;" SIGINT SIGTERM

mkdir -p ./samples/videos

# Caputre images over this many seconds, defaults to 20 minutes
# duration=${1:-1200}

# Take an image at this interval over the duration
# loop=$((duration < 3600 ? duration : 3600))

# while [ $duration -gt 0 ]; do
file="video-$(date +%Y-%m-%dT%H-%M-%S).mp4"
ffmpeg -f v4l2 -i /dev/video0 -t 300 -r 30 ./working/video-current.mp4
mv ./working/video-current.mp4 ./samples/videos/$file
rsync --remove-source-files -vP ./samples/videos/$file tim@mohiohio.com:buzzy/samples/videos/$file &
# sleep $loop
# duration=$((duration - loop))
echo "completed video capture $file"
# done

wait
echo "finished video"
