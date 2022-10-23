#!/bin/bash

trap "echo Exited!; exit;" SIGINT SIGTERM

while inotifywait -r -e modify,create,move ./samples; do
    rsync --remove-source-files -rvzh samples tim@mohiohio.com:buzzy
done

