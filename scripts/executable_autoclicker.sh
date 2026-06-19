#!/bin/bash
PIDFILE=/tmp/autoclicker.pid

if [ -f "$PIDFILE" ]; then
    kill $(cat "$PIDFILE") 2>/dev/null
    rm "$PIDFILE"
else
    python /home/cheetah/scripts/autoclicker.py &
    echo $! > "$PIDFILE"
fi
