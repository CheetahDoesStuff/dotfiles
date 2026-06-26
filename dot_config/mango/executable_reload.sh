#!/bin/bash
set +e

# --- Outputs ---
wlr-randr --output DP-1 --pos 0,0
wlr-randr --output HDMI-A-1 --pos 1920,0

# --- Portal / DBus env ---
systemctl --user unmask xdg-desktop-portal-wlr
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots

# --- Helper: kill a process by pattern and wait until it's actually gone ---
kill_and_wait() {
  local pattern="$1"
  local timeout="${2:-3}"
  pkill -9 -f "$pattern"
  local waited=0
  while pgrep -f "$pattern" >/dev/null 2>&1; do
    sleep 0.1
    waited=$(echo "$waited + 0.1" | bc)
    if (($(echo "$waited >= $timeout" | bc -l))); then
      echo "Warning: $pattern did not die within ${timeout}s"
      break
    fi
  done
}

# --- Quickshell ---
kill_and_wait "qs"
qs &
qs -p ~/.config/quickshell/launcher/launcher.qml &
qs -p ~/.config/quickshell/tool-launcher/tool-launcher.qml &

# --- snixembed ---
kill_and_wait "snixembed"
snixembed &

# --- xdg-desktop-portal-wlr ---
kill_and_wait "xdg-desktop-portal-wlr"
/usr/lib/xdg-desktop-portal-wlr &

# --- awww-daemon (wallpaper daemon) ---
kill_and_wait "awww-daemon"
awww-daemon &
sleep 0.5 # give the daemon's socket a moment to actually bind before anything tries to use it

# --- Clipboard history watchers ---
kill_and_wait "wl-paste --type text --watch cliphist"
wl-paste --type text --watch cliphist store &

kill_and_wait "wl-paste --type image --watch cliphist"
wl-paste --type image --watch cliphist store &

wait
