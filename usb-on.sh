#!/bin/bash
set -e

echo "startup usb"
/usr/sbin/uhubctl -l 1-1 -p 2 -a on
sleep 90
/usr/bin/tailscale up
