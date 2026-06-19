#! /bin/bash

set +e

wlr-randr --output DP-1 --pos 0,0
wlr-randr --output HDMI-A-1 --pos 1920,0

systemctl --user unmask xdg-desktop-portal-wlr &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots

killall waybar
waybar &

killall walker &
walker --gapplication-service &

killall elephant &
elephant &

killall snixembed &
snixembed &

/usr/lib/xdg-desktop-portal-wlr &
dunst &
awww-daemon &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store
