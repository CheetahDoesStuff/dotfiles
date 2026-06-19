#!/bin/bash

url=$(grim -g "$(slurp)" - | zbarimg --quiet --raw - 2>/dev/null)

echo "$url"

if [[ -n "$url" ]]; then
    xdg-open "$url"
    notify-send "QR Code Opened" "$url"
else
    notify-send "QR Code Not Found" "No URL detected in selection."
fi
