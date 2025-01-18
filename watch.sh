#!/bin/bash
cd "$(dirname "$0")"
set -e

trap "echo Watch Exited!; exit;" SIGINT SIGTERM
#trap 'echo "Inside trap"; echo "Line $LINENO."' ERR

mkdir -p ./samples/video
mkdir -p ./working

# Total duration, defaults to 20 minutes
duration=${1:-1200}

# duration will be split into into max 60 minute segments
segment=$((duration < 3600 ? duration : 3600))

while [ $duration -gt 0 ]; do
	echo "duration: $duration segment:$segment"
	file="video-$(date +%Y-%m-%dT%H-%M-%S).mp4"
	ffmpeg -f v4l2 -thread_queue_size 1024 -input_format nv12 -video_size 1024x768 -framerate 30 -i /dev/video0 -c:v h264_v4l2m2m -b:v 2.5M -t $segment -y ./working/video-current.mp4
	mv ./working/video-current.mp4 ./samples/video/$file
	rsync --remove-source-files -vP ./samples/video/$file tim@mohiohio.com:buzzy/samples/video/$file &
	duration=$((duration - segment))
	echo "completed segment $file"
done

wait
echo "finished watch"
