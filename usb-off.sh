#!/bin/bash
set -e

echo "shutdown tailscale"
/usr/bin/tailscale down --accept-risk=lose-ssh
sleep 30

echo "shutdown usb"
sleep 2
/usr/sbin/uhubctl -l 1-1 -p 2 -a off
