#!/bin/bash

mkdir -p ./samples/images

# 5 minutes = 300 sec

fswebcam -l 300 -S 20 -p YUYV -r 2592x1944 --save ./samples/images/pic-%Y-%m-%d_%H:%M:%S.jpg
