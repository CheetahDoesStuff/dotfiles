#!/usr/bin/env bash

TARGET="§fMCSR Practice §7v2.0.0 by Dibedy"
SAVES_DIR="/home/cheetah/.local/share/PrismLauncher/saves"

notify-send "Starting save cleanup..."

deleted_count=0
deleted_size=0

shopt -s nullglob

for dir in "$SAVES_DIR"/*; do
    name="$(basename "$dir")"

    if [ "$name" != "$TARGET" ]; then
        size=$(du -sb "$dir" 2>/dev/null | cut -f1)
        deleted_size=$((deleted_size + size))

        rm -rf -- "$dir"
        deleted_count=$((deleted_count + 1))
    fi
done

size_human=$(numfmt --to=iec "$deleted_size")

notify-send "Cleanup done! (${deleted_count} saves deleted, ${size_human} total)"
