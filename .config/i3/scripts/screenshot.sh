#!/usr/bin/env bash

# screenshot.sh - Take a screenshot and copy to clipboard / save to file

DIR="${HOME}/Pictures/Screenshots"
mkdir -p "$DIR"

FILENAME="${DIR}/screenshot_$(date +%Y%m%d_%H%M%S).png"

notify_success() {
    if [ -f "$1" ]; then
        if command -v dunstify &> /dev/null; then
            dunstify -a "screenshot" -u low -i "$1" "Screenshot Saved" "$(basename "$1")"
        else
            notify-send "Screenshot Saved" "$(basename "$1")"
        fi
    fi
}

take_screenshot() {
    mode=$1
    if command -v maim &> /dev/null; then
        if [ "$mode" = "full" ]; then
            maim "$FILENAME"
        elif [ "$mode" = "area" ]; then
            maim -s "$FILENAME"
        fi
    elif command -v scrot &> /dev/null; then
        if [ "$mode" = "full" ]; then
            scrot "$FILENAME"
        elif [ "$mode" = "area" ]; then
            scrot -s "$FILENAME"
        fi
    else
        notify-send "Error" "Please install maim or scrot to take screenshots."
        exit 1
    fi

    # Copy to clipboard if xclip is installed
    if [ -f "$FILENAME" ] && command -v xclip &> /dev/null; then
        xclip -selection clipboard -t image/png -i "$FILENAME"
    fi

    notify_success "$FILENAME"
}

case $1 in
    full)
        take_screenshot "full"
        ;;
    area)
        take_screenshot "area"
        ;;
    *)
        echo "Usage: $0 {full|area}"
        exit 2
        ;;
esac
