#!/usr/bin/env bash

# volume.sh - Adjust system volume and show dunst notification

get_volume() {
    if command -v pamixer &> /dev/null; then
        pamixer --get-volume
    else
        pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -n1
    fi
}

is_mute() {
    if command -v pamixer &> /dev/null; then
        pamixer --get-mute
    else
        pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes" && echo "true" || echo "false"
    fi
}

send_notification() {
    volume=$(get_volume)
    mute=$(is_mute)
    if [ "$mute" = "true" ] || [ "$volume" -eq 0 ]; then
        if command -v dunstify &> /dev/null; then
            dunstify -a "volume" -u low -r 9993 -i audio-volume-muted "Muted"
        else
            notify-send -t 1500 "Volume: Muted"
        fi
    else
        if command -v dunstify &> /dev/null; then
            dunstify -a "volume" -u low -r 9993 -h int:value:"$volume" "Volume: ${volume}%"
        else
            notify-send -t 1500 "Volume: ${volume}%"
        fi
    fi
}

case $1 in
    up)
        if command -v pamixer &> /dev/null; then
            pamixer -i 5
        else
            pactl set-sink-volume @DEFAULT_SINK@ +5%
        fi
        send_notification
        ;;
    down)
        if command -v pamixer &> /dev/null; then
            pamixer -d 5
        else
            pactl set-sink-volume @DEFAULT_SINK@ -5%
        fi
        send_notification
        ;;
    mute)
        if command -v pamixer &> /dev/null; then
            pamixer -t
        else
            pactl set-sink-mute @DEFAULT_SINK@ toggle
        fi
        send_notification
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 2
        ;;
esac
