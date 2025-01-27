#!/bin/bash
cd "$(dirname "$0")"
set -e

trap "echo Watch Exited!; exit;" SIGINT SIGTERM
#trap 'echo "Inside trap"; echo "Line $LINENO."' ERR

mkdir -p ./samples/video
mkdir -p ./working

# Total duration, defaults to 20 minutes
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

# duration will be split into into max 60 minute segments
segment=$((duration < 3600 ? duration : 3600))

# Function to convert time to seconds since epoch
time_to_seconds() {
	date -d "$1" +%s
}

# Wait until the target time is reached if provided
if [ -n "$sunrise" ]; then

	echo "Waiting until sunrise $sunrise"

	if ! [[ $sunrise =~ ^([01][0-9]|2[0-3]):[0-5][0-9]$ ]]; then
		echo "Error: sunrise must be in HH:MM format" >&2
		exit 1
	fi

	current_time=$(time_to_seconds "$(date +%H:%M)")
	target_time_seconds=$(time_to_seconds "$target_time")

	while [ "$current_time" -lt "$target_time_seconds" ]; do
		echo "Current time: $(date +%H:%M), waiting until $target_time..."
		sleep 60
		current_time=$(time_to_seconds "$(date +%H:%M)")
	done
fi

while [ $duration -gt 0 ]; do
	echo "duration: $duration segment:$segment"
	file="video-$(date +%Y-%m-%dT%H-%M-%S).mp4"
	ffmpeg -f v4l2 -thread_queue_size 1024 -input_format nv12 -video_size 1024x768 -framerate 30 -i /dev/video0 -c:v h264_v4l2m2m -b:v 1M -t $segment -y ./working/video-current.mp4
	mv ./working/video-current.mp4 ./samples/video/$file
	rsync --remove-source-files -vP ./samples/video/$file tim@mohiohio.com:buzzy/samples/video/$file &
	duration=$((duration - segment))
	echo "completed segment $file"
done

wait
echo "finished watch"
