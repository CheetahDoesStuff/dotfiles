#! /bin/bash
systemctl --user unmask xdg-desktop-portal-wlr &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots

/usr/lib/xdg-desktop-portal-wlr &
dunst &
swww-daemon &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

bash /home/cheetah/.config/mango/reload.sh
