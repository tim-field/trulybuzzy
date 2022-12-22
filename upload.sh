#!/bin/bash
cd "$(dirname "$0")"

#echo "startup usb"
#/usr/sbin/uhubctl -l 1-1 -p 2 -a on
#sleep 90

# also cleared in cron on reboot
PIDFILE=./upload.pid

trap "rm -f $PIDFILE; echo Uploader Exited!; exit;" SIGINT SIGTERM

# ensure single instance 
# https://gist.github.com/darth-veitcher/f47eb0a52ae42a1c5e9a65adca460723
if [ -f $PIDFILE ]
then
  PID=$(cat $PIDFILE)
  ps -p $PID > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    echo "Process already running"
    exit 1
  else
    ## Process not found assume not running
    echo $$ > $PIDFILE
    if [ $? -ne 0 ]
    then
      echo "Could not create PID file"
      exit 1
    fi
  fi
else
  echo $$ > $PIDFILE
  if [ $? -ne 0 ]
  then
    echo "Could not create PID file"
    exit 1
  fi
fi


# Main script ... Do work here

#while inotifywait -r -e modify,create,move ./samples; do
  rsync --remove-source-files -rcvhP samples tim@mohiohio.com:buzzy --log-file=upload.log
#done

# End


#echo "shutdown tailscale"
#/usr/bin/tailscale down --accept-risk=lose-ssh
#sleep 30

#echo "shutdown usb"
#sleep 2
#/usr/sbin/uhubctl -l 1-1 -p 2 -a off


rm $PIDFILE

