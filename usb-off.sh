#!/bin/bash
set -e

echo "shutdown usb"
sleep 2
sudo /usr/sbin/uhubctl -l 1-1 -p 2 -a off
