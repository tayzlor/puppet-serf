#!/bin/sh
#
# serf - this script starts and stops the serf service daemon
#
# chkconfig: 345 99 1
# description: serf
# processname: serf
# pidfile: /var/run/serf.pid

# Source function library.
. /etc/rc.d/init.d/functions

prog=serf
cmd="/usr/local/bin/${prog} agent"
pidfile="/var/run/${prog}.pid"
lockfile="/var/lock/subsys/${prog}"

SERF_CONFIG_DIR="<%= @lconfig_dir %>"
SERF_LOG_FILE="<%= @log_file %>"

[[ -f /etc/sysconfig/serf ]] && . /etc/sysconfig/serf

[[ -d $SERF_CONFIG_DIR ]] || mkdir -p $SERF_CONFIG_DIR

start() {
    echo -n $"Starting $prog: "
    daemon --pidfile=$pidfile "${cmd} -config-dir=$SERF_CONFIG_DIR >> $SERF_LOG_FILE &"
    retval=$?
    ps -ef | grep -F "${cmd}" | grep -v 'grep' | awk '{print $2}' > ${pidfile}
    [ $retval -eq 0 ] && touch $lockfile && success
    echo
    return $retval
}

stop() {
    echo -n $"Stopping $prog: "
    killproc -p $pidfile $prog
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

rh_status() {
    status $prog
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}

restart() {
    stop
    start
}

case "$1" in
start)
    rh_status_q && exit 0
    $1
    ;;
stop)
    #rh_status_q && exit 0
    $1
    ;;
restart)
    $1
    ;;
status|status_q)
    rh_$1
    ;;
*)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 2
esac
exit 0