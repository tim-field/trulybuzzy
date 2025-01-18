#!/bin/bash
set -e

echo "startup usb"
sudo /usr/sbin/uhubctl -l 1-1 -p 2 -a on
sleep 5
echo "started usb"
