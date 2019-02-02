#! /bin/sh
# /etc/init.d/lxc-on-boot.sh 

### BEGIN INIT INFO
# Provides:          service on boot
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
### END INIT INFO

# If you want a command to always run, put it here

# Carry out specific functions when asked to by the system
case "$1" in
  start)
      
    ;;
  stop)

    ;;
  *)
    echo "Usage: /etc/init.d/lxc-on-boot {start|stop}"
    exit 1
    ;;
esac

exit 0
