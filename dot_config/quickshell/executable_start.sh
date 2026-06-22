#!/bin/bash

pkill -x qs || true

while pgrep -x qs >/dev/null; do
    sleep 0.1
done

qs &
sleep 1
qs -p ~/.config/quickshell/notifications.qml &