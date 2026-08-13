#!/usr/bin/env bash

# brightness.sh - Adjust screen brightness and show dunst notification

# Check if brightnessctl is installed
if ! command -v brightnessctl &> /dev/null; then
    notify-send "Error" "brightnessctl could not be found. Please install it."
    exit 1
fi

get_brightness() {
    brightnessctl -m | cut -d, -f4 | tr -d '%'
}

send_notification() {
    brightness=$(get_brightness)
    # Use dunstify with an ID to replace the previous notification and prevent stack spamming
    if command -v dunstify &> /dev/null; then
        dunstify -a "brightness" -u low -r 9991 -h int:value:"$brightness" "Brightness: ${brightness}%"
    else
        notify-send -t 1500 "Brightness: ${brightness}%"
    fi
}

case $1 in
    up)
        brightnessctl set +5%
        send_notification
        ;;
    down)
        brightnessctl set 5%-
        send_notification
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 2
        ;;
esac
