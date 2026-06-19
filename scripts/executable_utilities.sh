#! /bin/bash

prompt=' '

option_1="  Take Screenshot"
opt_1_cmd=~/scripts/screenshot-selection.sh

option_2="󰐳  Scan QR Code"
opt_2_cmd=~/scripts/qrcode.sh

option_3="󰥷  Select Wallpaper"
opt_3_cmd=~/scripts/wallpaper-menu.sh

option_5=" Delete Saves"
opt_5_cmd=~/scripts/cleanup-saves.sh

option_4="󰐥  Power Menu"
opt_4_cmd=~/scripts/power-menu.sh

rofi_cmd() {
	rofi \
        -theme ~/.config/rofi/utilities-style.rasi \
        -dmenu \
	-p "$prompt" \
	-sep ',' \
	-i
}

run_rofi() {
	printf "$option_1,$option_2,$option_3,$option_5,$option_4" | rofi_cmd
}

case "$(run_rofi)" in
	$option_1) ${opt_1_cmd};;
	$option_2) ${opt_2_cmd};;
	$option_3) ${opt_3_cmd};;
	$option_5) ${opt_5_cmd};;
	$option_4) ${opt_4_cmd};;
esac
