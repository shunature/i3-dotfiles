#!/usr/bin/env bash

# sysmenu.sh - Rofi power menu

# Options
shutdown="襤 Shutdown"
reboot="ﰇ Reboot"
lock=" Lock"
suspend="鈴 Suspend"
logout=" Logout"

# Get answer from user via rofi
selected_option=$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi -dmenu -i -p "Power Menu:" -theme-str 'window {width: 250px; height: 280px;} listview {lines: 5; columns: 1;}')

# Actions based on choice
case $selected_option in
    *"Lock")
        if command -v i3lock &> /dev/null; then
            i3lock -c 1e1e2e
        else
            notify-send "Error" "i3lock is not installed"
        fi
        ;;
    *"Suspend")
        systemctl suspend
        ;;
    *"Logout")
        i3-msg exit
        ;;
    *"Reboot")
        systemctl reboot
        ;;
    *"Shutdown")
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
