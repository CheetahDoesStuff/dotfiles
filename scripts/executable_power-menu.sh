#! /bin/bash

lock=''
lock_cmd='hyprlock'

logout='󰗽'
logout_cmd='killall mango'

reboot=''
reboot_cmd='systemctl reboot'

shutdown='󰐥'
shutdown_cmd='systemctl poweroff'


rofi_cmd() {
	rofi \
        -theme ~/.config/rofi/powermenu-style.rasi \
        -dmenu \
	-sep ','
}

run_rofi() {
	printf "$lock,$logout,$reboot,$shutdown" | rofi_cmd
}

case "$(run_rofi)" in
	$lock) ${lock_cmd};;
	$logout) ${logout_cmd};;
	$reboot) ${reboot_cmd};;
	$shutdown) ${shutdown_cmd};;
esac
